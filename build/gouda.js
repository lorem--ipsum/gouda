var _gatherVariables, _replaceVariables, _stripVariables;

_gatherVariables = function(string) {
  var variables;
  if (!string) {
    return {};
  }
  variables = {};
  (string.match(/__[^\s]+\([^)]+\)\s*:[^\n\r]+/g) || []).forEach(function(group) {
    var full, key, parameters, value, _ref;
    _ref = group.match(/__(\w+)\(([^)]+)\)\s*:\s*(.*)$/), full = _ref[0], key = _ref[1], parameters = _ref[2], value = _ref[3];
    parameters = parameters.split(/\s*,\s*/g);
    return variables[key] = function(st) {
      var callerKey, callerParameters, unescapedValue, _ref1;
      _ref1 = st.match(/__([^\s]+)\(([^)]+)\)/), st = _ref1[0], callerKey = _ref1[1], callerParameters = _ref1[2];
      callerParameters = callerParameters.split(/\s*,\s*/g);
      unescapedValue = value;
      callerParameters.forEach(function(p, i) {
        var paramKey;
        paramKey = parameters[i];
        return unescapedValue = unescapedValue.replace("_" + paramKey + "_", p);
      });
      return unescapedValue;
    };
  });
  (string.match(/__[^\s]+\([^)]+\)\s*:\s*%%%[^%%%]+%%%/g) || []).forEach(function(group) {
    var full, key, parameters, value, _ref;
    _ref = group.match(/__(\w+)\(([^)]+)\)\s*:\s*%%%\s*([^%%%]+)\s*%%%$/), full = _ref[0], key = _ref[1], parameters = _ref[2], value = _ref[3];
    value = value.replace(/\s*$/, '');
    parameters = parameters.split(/\s*,\s*/g);
    return variables[key] = function(st) {
      var callerKey, callerParameters, unescapedValue, _ref1;
      _ref1 = st.match(/__([^\s]+)\(([^)]+)\)/), st = _ref1[0], callerKey = _ref1[1], callerParameters = _ref1[2];
      callerParameters = callerParameters.split(/\s*,\s*/g);
      unescapedValue = value;
      callerParameters.forEach(function(p, i) {
        var paramKey;
        paramKey = parameters[i];
        return unescapedValue = unescapedValue.replace("_" + paramKey + "_", p);
      });
      return unescapedValue;
    };
  });
  (string.match(/__[^\s]+:[^\n\r]+/g) || []).forEach(function(group) {
    var key, value, _ref;
    _ref = group.split(/\s*:\s*/), key = _ref[0], value = _ref[1];
    return variables[key.replace(/^__/, '')] = function() {
      return value.replace(/\s*$/, '');
    };
  });
  (string.match(/__[^\s]+\s*:\s*%%%[^%%%]+%%%/g) || []).forEach(function(group) {
    var key, value, _ref;
    _ref = group.split(/\s*:\s*%%%\s*/), key = _ref[0], value = _ref[1];
    return variables[key.replace(/^__/, '')] = function() {
      return value.replace(/\s*%%%\s*$/, '');
    };
  });
  return variables;
};

_stripVariables = function(string) {
  return string.replace(/__[^:]+\s*:\s*%%%[^%%%]+%%%\s*/g, '').replace(/__[^\s]+\s*:\s*[^\n\r]+\s*/g, '');
};

_replaceVariables = function(string, variables) {
  return string.replace(/__([a-zA-Z]+)(?:\(([^)]+)\))?/g, function(match, key, params) {
    if (variables[key] === void 0) {
      throw new Error("Unknow variable : __" + key);
    }
    return variables[key](match);
  });
};

module.exports = {
  compute: function(string) {
    var variables;
    variables = _gatherVariables(string);
    string = _stripVariables(string);
    return _replaceVariables(string, variables);
    return string;
  }
};
