#!/bin/sh

test_description='functional tests'

. ./sharness.sh

test_expect_success 'setup' '
	test -e jsonaxe || ln -s ../../jsonaxe &&
	test -e data || ln -s ../data.json data
'

test_expect_success 'strings are quoted' '
	echo "\"string value\"" >expect &&
	./jsonaxe string data >actual &&
	test_cmp expect actual
'

test_expect_success 'raw strings are not quoted' '
	echo string value >expect &&
	./jsonaxe --raw string data >actual &&
	test_cmp expect actual
'

test_expect_success 'nested objects looked up using dot syntax' '
	echo "C value" >expect &&
	./jsonaxe --raw objects.a.b.c data >actual &&
	test_cmp expect actual
'

test_expect_success 'raw arrays of strings are listed one line at a time' '
	echo a >expect &&
	echo b >>expect &&
	./jsonaxe --raw stringarray data >actual &&
	test_cmp expect actual
'

test_expect_success 'raw dicts are indented with tabs' '
	cat >expect <<\-EOF &&
a:
	a value
b:
	b value
c:
	d
	e:
		88
-EOF
	./jsonaxe --raw dict data >actual &&
	test_cmp expect actual
'

test_expect_success 'raw nested string arrays are flattened' '
	echo a >expect &&
	echo b >>expect &&
	./jsonaxe --raw stringarray2 data >actual &&
	test_cmp expect actual
'

test_expect_success 'can get key names' '
	cat > expect <<\-EOF &&
a
b
c
-EOF
	./jsonaxe --raw "dict.keys()" data >actual &&
	test_cmp expect actual
'

test_expect_success 'can filter data using regular expressions' '
	cat > expect <<\-EOF &&
a
ab
-EOF
	./jsonaxe --raw "dict2.match(\"a.*\").keys()" data >actual &&
	test_cmp expect actual
'

test_expect_success 'can filter data using fnmatch expressions' '
	cat > expect <<\-EOF &&
b
bc
-EOF
	./jsonaxe --raw "dict2.fnmatch(\"b*\").keys()" data >actual &&
	test_cmp expect actual
'

test_expect_success 'can sort data in place' '
	cat > expect <<\-EOF &&
1
2
3
-EOF
	./jsonaxe --raw "unsorted.sort()" data >actual &&
	test_cmp expect actual
'

test_expect_success 'can capitalize strings' '
	echo String value >expect &&
	./jsonaxe --raw "string.capitalize()" data >actual &&
	test_cmp expect actual
'

test_expect_success 'can make strings uppercase' '
	echo STRING VALUE >expect &&
	./jsonaxe --raw "string.upper()" data >actual &&
	test_cmp expect actual
'

test_expect_success 'can delete dict entries' '
	cat >expect <<\-EOF &&
a:
	a value
b:
	b value
-EOF
	jsonaxe --raw "dict.delete(\"c\")" data >actual &&
	test_cmp expect actual
'

test_expect_success 'can format dicts' '
	echo "a value, b value" >expect &&
	jsonaxe --raw "dict.format(\"{a}, {b}\")" data >actual &&
	test_cmp expect actual
'

test_expect_success 'can replace data in dicts' '
	echo "a value8b value" >expect &&
	./jsonaxe --raw "dict.put(\"c\", 8).format(\"{a}{c}{b}\")" data >actual &&
	test_cmp expect actual
'

test_expect_success 'can replace data in arrays' '
	cat >expect <<\-EOF &&
4
2
1
-EOF
	./jsonaxe --raw "unsorted.put(0, 4)" data >actual &&
	test_cmp expect actual
'

test_expect_success 'can insert data in arrays' '
	cat >expect <<\-EOF &&
4
3
2
1
-EOF
	./jsonaxe --raw "unsorted.insert(0, 4)" data >actual &&
	test_cmp expect actual
'

test_expect_success 'can reverse data in arrays' '
	cat >expect <<\-EOF &&
3
2
1
-EOF
	./jsonaxe --raw "sorted.reverse()" data >actual &&
	test_cmp expect actual
'

test_expect_success 'can split strings and map a function to the result' '
	cat >expect <<\-EOF &&
6
5
-EOF
	./jsonaxe --raw "string.split().map(len)" data >actual &&
	test_cmp expect actual
'

test_expect_success 'can rstrip() whitespace from strings' '
	cat >expect <<\-EOF &&
    OK
-EOF
	./jsonaxe --raw "string.rstrip()" >actual <<\-EOF &&
{"string": "    OK    "}
-EOF
	test_cmp expect actual
'

test_expect_success 'can lstrip() whitespace from strings' '
	cat >expect <<\-EOF &&
OK    
-EOF
	./jsonaxe --raw "string.lstrip()" >actual <<\-EOF &&
{"string": "    OK    "}
-EOF
	test_cmp expect actual
'

test_expect_success 'can strip() whitespace from strings' '
	cat >expect <<\-EOF &&
OK
-EOF
	./jsonaxe --raw "string.strip()" >actual <<\-EOF &&
{"string": "    OK    "}
-EOF
	test_cmp expect actual
'

test_expect_success 'can get() list items' '
    cat >expect <<\-EOF &&
42
-EOF
    ./jsonaxe "get(1)" >actual <<\-EOF &&
[24, 42, 88]
-EOF
    test_cmp expect actual
'

test_expect_success 'can get() dict items' '
    cat >expect <<\-EOF &&
42
-EOF
    ./jsonaxe "get(\"1\")" >actual <<\-EOF &&
{"0": 24, "1": 42, "2": 88}
-EOF
    test_cmp expect actual
'


test_done
