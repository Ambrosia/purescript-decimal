// module Data.BigInt

var Decimal = require("decimal.js");

exports.construct = function(Just) {
  return function(Nothing) {
    return function (n) {
      try {
        return Just(new Decimal(n));
      } catch (err) {
        return Nothing;
      }
    }
  }
};

exports.fromInt = function(s) {
  return new Decimal(s);
};

exports.fromNumber = function(s) {
  return new Decimal(s);
};

exports.toString = function(x) {
  return x.toString();
};

exports.toNumber = function(x) {
  return x.toNumber();
};

exports.dAdd = function(x) {
  return function(y) {
    return x.add(y);
  };
};

exports.dMul = function(x) {
  return function(y) {
    return x.mul(y);
  };
};

exports.dSub = function(x) {
  return function(y) {
    return x.sub(y);
  };
};

exports.dMod = function(x) {
  return function(y) {
    return x.mod(y);
  };
};

exports.dDiv = function(x) {
  return function(y) {
    return x.div(y);
  };
};

exports.dEquals = function(x) {
  return function(y) {
    return x.equals(y);
  };
};

exports.dCompare = function(x) {
  return function(y) {
    return x.cmp(y);
  };
};

exports.abs = function(x) {
  return x.abs();
};

exports.pow = function(x) {
  return function(y) {
    return x.pow(y);
  };
};

exports.intDiv = function(x) {
  return function(y) {
    return x.divToInt(y);
  };
};
