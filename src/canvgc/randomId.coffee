ID_CHARS = "23456789ABCDEFGHJKLMNPQRSTWXYZabcdefghijkmnopqrstuvwxyz"
ID_CHARS_LEN = ID_CHARS.length

randomId = (prefix='', n=6)->
  digits = '';
  for i in [0..n]
    digits += ID_CHARS.charAt(Math.floor(Math.random() * ID_CHARS_LEN))
  return prefix + digits;

module.exports = randomId;