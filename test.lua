local utf8 = require 'utf8'
local unpack = unpack or table.unpack

local function get_codes(s)
    return table.concat({utf8.byte(s, 1, -1)}, ' ')
end

local t = { 20985, 20984, 26364, 25171, 23567, 24618, 20861 }

-- test escape & len
assert(get_codes(utf8.escape"%123%xabc%x{ABC}%d%u{456}") == '123 2748 2748 100 456')

local s = utf8.escape('%'..table.concat(t, '%'))
assert(utf8.len(s) == 7)
assert(get_codes(s) == table.concat(t, ' '))

-- test char
assert(s == utf8.char(unpack(t)))

-- test range
for i = 1, #t do
    assert(utf8.byte(s, i) == t[i])
end

-- test sub
assert(get_codes(utf8.sub(s, 2, -2)) == table.concat(t, ' ', 2, #t-1))


assert(utf8.insert("abcdef", "...") == "abcdef...")
assert(utf8.insert("abcdef", 0, "...") == "abcdef...")
assert(utf8.insert("abcdef", 1, "...") == "...abcdef")
assert(utf8.insert("abcdef", 6, "...") == "abcde...f")
assert(utf8.insert("abcdef", 7, "...") == "abcdef...")
assert(utf8.insert("abcdef", 3, "...") == "ab...cdef")
assert(utf8.insert("abcdef", -3, "...") == "abc...def")
assert(utf8.remove("abcdef", 3, 3) == "abdef")
assert(utf8.remove("abcdef", 3, 4) == "abef")
assert(utf8.remove("abcdef", 4, 3) == "abcdef")
assert(utf8.remove("abcdef", -3, -3) == "abcef")
assert(utf8.remove("abcdef", 100) == "abcdef")
assert(utf8.remove("abcdef", -100) == "")
assert(utf8.remove("abcdef", -100, -200) == "abcdef")
assert(utf8.remove("abcdef", -200, -100) == "abcdef")

assert(utf8.next"abc" == 1)
assert(utf8.next("abc", 3) == nil)
assert(utf8.next("abc", 4) == nil)
assert(utf8.next("abc", 3, -3) == 1)
assert(utf8.next("abc", 3, -4) == nil)

assert(utf8.ncasecmp("abc", "AbC") == 0)
assert(utf8.ncasecmp("abc", "AbE") == -1)
assert(utf8.ncasecmp("abe", "AbC") == 1)
assert(utf8.ncasecmp("abc", "abcdef") == -1)
assert(utf8.ncasecmp("abcdef", "abc") == 1)
assert(utf8.ncasecmp("abZdef", "abcZef") == 1)

print "OK"
