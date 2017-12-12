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


function DefaultTable(init)
  local res = init
  if res == nil then
    res = {}
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
function mptikz.draw_node(legs, props)
  local legs = DefaultTable(legs)
  local props = DefaultTable(ifelse(props ~= nil, props, {}))

  local w = props:get('width', 1)
  local h = props:get('height', 1)
  local name = props:get('name', 'T')
  local l_vleg = props:get('l_vleg', 0.5)
  local l_hleg = props:get('l_hleg', 0.25)

  t('\\begin{scope}[shift={(%f,%f)}]', props:get('x', 0), props:get('y', 0))
  -- draw the legs first
  draw_legs('N', legs:get('N', 0), l_vleg, w, h, name)
  draw_legs('S', legs:get('S', 0), l_vleg, w, h, name)
  draw_legs('E', legs:get('E', 0), l_hleg, w, h, name)
  draw_legs('W', legs:get('W', 0), l_hleg, w, h, name)


  -- draw the node body
  local rect_src = string.format('\\draw[tensornode] (%f,%f) rectangle (%f,%f) {};', -w/2, -h/2, w/2, h/2)
  t('\\node (%s) at (0,0) {\\tikz{%s}};', name, rect_src)
  t('\\end{scope}')
end


return mptikz
