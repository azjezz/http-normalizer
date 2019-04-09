# HTTP Normalizer

Normalize Http super globals.

---

## Installation

This package can be install with Composer.

```
$ composer require azjezz/http-normalizer
```

---

## Usage

### Normalize

> Normalize super globals : `$_GET`, `$_POST`, and `$_COOKIE` ... etc :

```hack
$_GET = [
  'a' => ['b' => '4'],
  'c' => [0 => 4, 'c' => ['s' => ['f' => [0 => '3']]]],
  'b' => '3',
  'foo' => [0 => 'baz', 1 => 'qux'],
];

$query = AzJezz\HttpNormalizer\normalize($_GET);

/**
 * vec [
 *   tuple("a[b]", "4"),
 *   tuple("c[0]", "4"),
 *   tuple("c[c][s][f][0]", "3"),
 *   tuple("b", "3"),
 *   tuple("foo[0]", "baz"),
 *   tuple("foo[1]", "qux"),
 * ]
 */
```

> Normalize `$_FILES` super global :

```hack
$_FILES = [
  'slide-shows' => [
    'tmp_name' => [
      0 => ['slides' => [0 => 'tmpfoo', 1 => 'tmpbar']],
    ],
    'error' => [0 => ['slides' => [0 => 0, 1 => 0]]],
    'name' => [0 => ['slides' => [0 => 'foo.txt', 1 => 'bar.txt']]],
    'size' => [0 => ['slides' => [0 => 123, 1 => 200]]],
    'type' => [0 => ['slides' => [0 => 'text/plain', 1 => 'text/plain']]],
  ],
];

$files = AzJezz\HttpNormalizer\normalize_files($_FILES);

/**
 * vec [
 *   tuple("slide-shows[0][slides][0]", shape(
 *     'tmp_name' => 'tmpfoo',
 *     'size' => 123,
 *     'error' => 0,
 *     'name' => 'foo.txt',
 *     'type' =>'text/plain',
 *   )),
 *   tuple("slide-shows[0][slides][1]", shape(
 *     'tmp_name' => 'tmpbar',
 *     'size' => 200,
 *     'error' => 0,
 *     'name' => 'bar.txt',
 *     'type' =>'text/plain',
 *   )),
 * ]
 */
```

### Parse

> Parse http request body, query strings, cookie strings ... etc :

```hack
$input = 'a=b&c[]=4&b=3&a[b]=4&c[c][s][f][]=3&foo[]=baz&foo[]=qux';
$query = AzJezz\HttpNormalizer\parse($input);

/**
 * vec [
 *   tuple("a[b]", "4"),
 *   tuple("c[0]", "4"),
 *   tuple("c[c][s][f][0]", "3"),
 *   tuple("b", "3"),
 *   tuple("foo[0]", "baz"),
 *   tuple("foo[1]", "qux"),
 * ]
 */
```

---

## License

The Http Normalizer Project is open-sourced software licensed under the MIT-licensed.
