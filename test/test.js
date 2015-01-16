var compute, expect;

compute = require('../build/swiss').compute;

expect = require('chai').expect;

describe('swiss', function() {
  it('should return a string', function() {
    expect(compute('blah')).to.be.a('string');
  });
  it('should work with parametrized single line variables', function() {
    var input, output;
    input = "__blue(opacity): hsla(197, 60%, 52%, _opacity_)\n\n.info-bubble {\n  background-color: __blue(1);\n}\n\n.info-label {\n  color: __blue(0.2);\n}";
    output = ".info-bubble {\n  background-color: hsla(197, 60%, 52%, 1);\n}\n\n.info-label {\n  color: hsla(197, 60%, 52%, 0.2);\n}";
    expect(compute(input)).to.equal(output);
  });
  it('should work with parametrized multi line variables', function() {
    var input, output;
    input = "__label(a, b,c) :%%%\n  .info-label {\n    background-color: _a_;\n    font-size: _b_;\n    font-weight: _c_;\n  }\n%%%\n\n.notification {\n  position: relative;\n\n  __label(foo, \"bar\", -baz)\n}";
    output = ".notification {\n  position: relative;\n\n  .info-label {\n    background-color: foo;\n    font-size: \"bar\";\n    font-weight: -baz;\n  }\n}";
    expect(compute(input)).to.equal(output);
  });
  it('should work with single line variables', function() {
    var input, output;
    input = "__blue: hsla(197, 60%, 52%, 1)\n\n.info-bubble {\n  background-color: __blue;\n}\n\n.info-label {\n  color: __blue;\n}";
    output = ".info-bubble {\n  background-color: hsla(197, 60%, 52%, 1);\n}\n\n.info-label {\n  color: hsla(197, 60%, 52%, 1);\n}";
    expect(compute(input)).to.equal(output);
  });
  it('should throw an error for unknow variable', function() {
    expect(function() {
      return compute('__pouet');
    }).to["throw"]();
  });
  return it('should work with multiline variables', function() {
    var input, output;
    input = "__label :%%%\n  .info-label {\n    background-color: blue;\n    font-size: yomama;\n  }\n%%%\n\n.notification {\n  position: relative;\n\n  __label\n}";
    output = ".notification {\n  position: relative;\n\n  .info-label {\n    background-color: blue;\n    font-size: yomama;\n  }\n}";
    expect(compute(input)).to.equal(output);
  });
});
