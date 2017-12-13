local mptikz = {}

-- Helper functions -----------------------------------------------------------
function t(str, ...)
  local arg = {...}
  tex.print(string.format(str, unpack(arg)))
end


function ifelse(cond, val_t, val_f)
  if cond then
    return val_t
  else
    return val_f
  end
end


function ifnotnil(val, default)
  return ifelse(val ~= nil, val, default)
end


function table.clone(original)
  local copy = {}
  for key, value in pairs(original) do
    copy[key] = value
  end
  return copy
end


function table.update(dict, new_vals)
  local new_dict = table.clone(dict)
  for key, val in pairs(new_vals) do
    new_dict[key] = val
  end
  return new_dict
end


function DefaultTable(init, defaults)
  local res = ifnotnil(defaults, {})
  if init ~= nil then
    res = table.update(res, init)
  end

  function res:get (key, value)
    return ifelse(self[key] ~= nil, self[key], value)
  end

  return res
end


function draw_legs(orientation, nr, leglen, width, height, props)
  for i = 1,nr do
    local x1
    local x2
    local y1
    local y2
    local name

    if orientation == 'N' then
      x1 = (i / (nr + 1) - 0.5) * width
      x2 = x1
      y1 = height/2
      y2 = y1 + leglen
      name = string.format('%s_N%i', props['tensor_name'], i)

    elseif orientation == 'S' then
      x1 = (i / (nr + 1) - 0.5) * width
      x2 = x1
      y1 = -height/2
      y2 = y1 - leglen
      name = string.format('%s_S%i', props['tensor_name'], i)

    elseif orientation == 'W' then
      x1 = -width/2
      x2 = x1 - leglen
      y1 = (i / (nr + 1) - 0.5) * width
      y2 = y1
      name = string.format('%s_W%i', props['tensor_name'], i)

    elseif orientation == 'E' then
      x1 = width/2
      x2 = x1 + leglen
      y1 = (i / (nr + 1) - 0.5) * width
      y2 = y1
      name = string.format('%s_E%i', props['tensor_name'], i)

    else
      error(string.format('%s is not a valid orientation', orientation))
    end

    t('\\draw[%s] (%f,%f) -- coordinate[midway] (%s) (%f,%f) coordinate (%s);',
      props['leg_style'], x1, y1, name, x2, y2, name .. 'e')
  end
end


-- Public functions -----------------------------------------------------------

mptikz.defaults = {
  len_vertical_legs = 0.25,
  len_horizontal_legs = 0.25,
  tensor_height = 1,
  tensor_width = 1,
  tensor_name = 'T',
  tensor_style = 'draw, fill=orange, rounded corners=0.1cm',
  leg_style = 'thick',
  N = 0, W = 0, S = 0, E = 0, virtual=1
}

function mptikz.draw_node(props)
  local props = DefaultTable(props, mptikz.defaults)

  local w = props['tensor_width']
  local h = props['tensor_height']

  t('\\begin{scope}[shift={(%f,%f)}]', props:get('x', 0), props:get('y', 0))

  -- draw the legs first
  draw_legs('N', props['N'], props['len_vertical_legs'], w, h, props)
  draw_legs('S', props['S'], props['len_vertical_legs'], w, h, props)
  draw_legs('E', props['E'], props['len_horizontal_legs'], w, h, props)
  draw_legs('W', props['W'], props['len_horizontal_legs'], w, h, props)

  -- draw the node body
  local rect_src = string.format('\\draw[%s] (%f,%f) rectangle (%f,%f) {};',
                                 props['tensor_style'], -w/2, -h/2, w/2, h/2)
  t('\\node (%s) at (0,0) {\\tikz{%s}};', props['tensor_name'], rect_src)
  t('\\end{scope}')
end


function mptikz.draw_mpa(sites, props)
  local props = DefaultTable(props, mptikz.defaults)

  local total_width = 2 * props['len_horizontal_legs'] + props['tensor_width']

  for site = 0, sites - 1 do
    local updates = {
      W = ifelse(site > 0, props['virtual']),
      E = ifelse(site < sites - 1, props['virtual']),
      x = props:get('x', 0) + site * total_width,
      tensor_name = string.format('%s_%i', props['tensor_name'], site + 1)
    }
    mptikz.draw_node(table.update(props, updates))
  end
end


return mptikz
