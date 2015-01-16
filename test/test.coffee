{compute}  = require '../build/swiss'
{expect} = require 'chai'

describe 'swiss', ->
  it 'should return a string', ->
    expect(compute('blah')).to.be.a('string')
    return

  it 'should work with parametrized single line variables', ->
    input = """
    __blue(opacity): hsla(197, 60%, 52%, _opacity_)

    .info-bubble {
      background-color: __blue(1);
    }

    .info-label {
      color: __blue(0.2);
    }
    """

    output = """
    .info-bubble {
      background-color: hsla(197, 60%, 52%, 1);
    }

    .info-label {
      color: hsla(197, 60%, 52%, 0.2);
    }
    """

    expect(compute(input)).to.equal(output)

    return

  it 'should work with parametrized multi line variables', ->
    input = """
    __label(a, b,c) :%%%
      .info-label {
        background-color: _a_;
        font-size: _b_;
        font-weight: _c_;
      }
    %%%

    .notification {
      position: relative;

      __label(foo, "bar", -baz)
    }
    """

    # this is bullshit ^^
    output = """
    .notification {
      position: relative;

      .info-label {
        background-color: foo;
        font-size: "bar";
        font-weight: -baz;
      }
    }
    """

    expect(compute(input)).to.equal(output)

    return

  it 'should work with single line variables', ->
    input = """
    __blue: hsla(197, 60%, 52%, 1)

    .info-bubble {
      background-color: __blue;
    }

    .info-label {
      color: __blue;
    }
    """

    output = """
    .info-bubble {
      background-color: hsla(197, 60%, 52%, 1);
    }

    .info-label {
      color: hsla(197, 60%, 52%, 1);
    }
    """

    expect(compute(input)).to.equal(output)

    return

  it 'should throw an error for unknow variable', ->
    expect(-> compute('__pouet')).to.throw()
    return

  it 'should work with multiline variables', ->
    input = """
    __label :%%%
      .info-label {
        background-color: blue;
        font-size: yomama;
      }
    %%%

    .notification {
      position: relative;

      __label
    }
    """

    output = """
    .notification {
      position: relative;

      .info-label {
        background-color: blue;
        font-size: yomama;
      }
    }
    """

    expect(compute(input)).to.equal(output)

    return
