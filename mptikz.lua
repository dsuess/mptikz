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


function draw_legs(orientation, nr, leglen, width, height, tname)
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
      name = string.format('%s_N%i', tname, i)

    elseif orientation == 'S' then
      x1 = (i / (nr + 1) - 0.5) * width
      x2 = x1
      y1 = -height/2
      y2 = y1 - leglen
      name = string.format('%s_S%i', tname, i)

    elseif orientation == 'W' then
      x1 = -width/2
      x2 = x1 - leglen
      y1 = (i / (nr + 1) - 0.5) * width
      y2 = y1
      name = string.format('%s_W%i', tname, i)

    elseif orientation == 'E' then
      x1 = width/2
      x2 = x1 + leglen
      y1 = (i / (nr + 1) - 0.5) * width
      y2 = y1
      name = string.format('%s_E%i', tname, i)

    else
      error(string.format('%s is not a valid orientation', orientation))
    end

    t('\\draw[tensorleg] (%f,%f) -- coordinate[midway] (%s) (%f,%f);', x1, y1, name, x2, y2)
  end
end


-- Public functions -----------------------------------------------------------

mptikz.defaults = {
  len_vertical_legs = 1.5,
  len_horizontal_legs = 0.25,
  tensor_height = 1,
  tensor_width = 1,
  tensor_name = 'T'
}

function mptikz.draw_node(legs, props)
  local legs = DefaultTable(legs, {N=0, E=0, S=0, W=0})
  local props = DefaultTable(props, mptikz.defaults)

  local w = props['tensor_width']
  local h = props['tensor_height']
  local name = props['tensor_name']

  t('\\begin{scope}[shift={(%f,%f)}]', props:get('x', 0), props:get('y', 0))

  -- draw the legs first
  draw_legs('N', legs['N'], props['len_vertical_legs'], w, h, name)
  draw_legs('S', legs['S'], props['len_vertical_legs'], w, h, name)
  draw_legs('E', legs['E'], props['len_horizontal_legs'], w, h, name)
  draw_legs('W', legs['W'], props['len_horizontal_legs'], w, h, name)

  -- draw the node body
  local rect_src = string.format('\\draw[tensornode] (%f,%f) rectangle (%f,%f) {};', -w/2, -h/2, w/2, h/2)
  t('\\node (%s) at (0,0) {\\tikz{%s}};', name, rect_src)
  t('\\end{scope}')
end


function mptikz.draw_mpa(sites, legs, props)
  local legs = DefaultTable(legs, {N=0, E=0, S=0, W=0, virtual=1})
  local props = DefaultTable(props, mptikz.defaults)

  local total_width = 2 * props['len_vertical_legs'] + props['tensor_width']

  for site = 0, sites - 1 do
    local x = props:get('x', 0) + site * total_width
    local leg_updates = {
      W = ifelse(site > 0, legs['virtual']),
      E = ifelse(site < sites - 1, legs['virtual'])
    }
    mptikz.draw_node(table.update(legs, leg_updates), table.update(props, {x=x}))
  end
end


return mptikz
