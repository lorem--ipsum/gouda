_gatherVariables = (string) ->
  return {} unless !!string

  variables = {}

  # Single line parametrized
  (string.match(/__[^\s]+\([^)]+\)\s*:[^\n\r]+/g) or []).forEach (group) ->

    [full, key, parameters, value] = group.match(/__(\w+)\(([^)]+)\)\s*:\s*(.*)$/)
    parameters = parameters.split(/\s*,\s*/g)

    variables[key] = (st) ->
      [st, callerKey, callerParameters] = st.match(/__([^\s]+)\(([^)]+)\)/)
      callerParameters = callerParameters.split(/\s*,\s*/g)

      unescapedValue = value
      callerParameters.forEach (p, i) ->
        paramKey = parameters[i]
        unescapedValue = unescapedValue.replace("_#{paramKey}_", p)

      return unescapedValue

  # Multi line parametrized
  (string.match(/__[^\s]+\([^)]+\)\s*:\s*%%%[^%%%]+%%%/g) or []).forEach (group) ->

    [full, key, parameters, value] = group.match(/__(\w+)\(([^)]+)\)\s*:\s*%%%\s*([^%%%]+)\s*%%%$/)
    value = value.replace(/\s*$/, '')
    parameters = parameters.split(/\s*,\s*/g)

    variables[key] = (st) ->
      [st, callerKey, callerParameters] = st.match(/__([^\s]+)\(([^)]+)\)/)
      callerParameters = callerParameters.split(/\s*,\s*/g)

      unescapedValue = value
      callerParameters.forEach (p, i) ->
        paramKey = parameters[i]
        unescapedValue = unescapedValue.replace("_#{paramKey}_", p)

      return unescapedValue

  # Single line
  (string.match(/__[^\s]+:[^\n\r]+/g) or []).forEach (group) ->
    [key, value] = group.split(/\s*:\s*/)
    variables[key.replace(/^__/, '')] = -> value.replace(/\s*$/, '')

  # Multi line
  (string.match(/__[^\s]+\s*:\s*%%%[^%%%]+%%%/g) or []).forEach (group) ->
    [key, value] = group.split(/\s*:\s*%%%\s*/)
    variables[key.replace(/^__/, '')] = -> value.replace(/\s*%%%\s*$/, '')

  return variables


_stripVariables = (string) ->
  return string
    .replace(/__[^:]+\s*:\s*%%%[^%%%]+%%%\s*/g, '')
    .replace(/__[^\s]+\s*:\s*[^\n\r]+\s*/g, '')


_replaceVariables = (string, variables) ->
  return string.replace(/__([a-zA-Z]+)(?:\(([^)]+)\))?/g, (match, key, params) ->
    if variables[key] is undefined
      throw new Error("Unknow variable : __#{key}")
    return variables[key](match)
  )

module.exports = {
  compute: (string) ->
    variables = _gatherVariables(string)
    string = _stripVariables(string)

    return _replaceVariables(string, variables)


    return string
}
