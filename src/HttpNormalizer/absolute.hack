namespace AzJezz\HttpNormalizer;

use namespace HH\Lib\Str;
use namespace HH\Lib\Vec;
use namespace HH\Lib\Dict;
use namespace Facebook\TypeSpec;

type FileStructure = shape(
  'tmp_name' => string,
  'size' => ?int,
  'error' => int,
  ?'name' => ?string,
  ?'type' => ?string,
  ...
);

function parse(string $body): vec<(string, string)> {
  $input = dict[];
  \parse_str($body, &$input);
  return normalize($input);
}

function normalize(
  KeyedContainer<arraykey, mixed> $input,
  ?string $prefix = null,
): vec<(string, string)> {
  $result = vec[];
  foreach ($input as $index => $value) {
    if ($prefix is nonnull) {
      $index = Str\format('%s[%s]', $prefix, (string)$index);
    } else {
      $index = (string)$index;
    }

    if ($value is string || $value is num) {
      $result[] = tuple($index, (string)$value);
      continue;
    }

    $spec = TypeSpec\dict(TypeSpec\arraykey(), TypeSpec\mixed());
    $result = Vec\concat($result, normalize($spec->coerceType($value), $index));
  }

  return $result;
}

function normalize_files(
  KeyedContainer<arraykey, mixed> $files,
): vec<(string, FileStructure)> {
  $files = new _Private\FileNormalizer()
    |> $$->normalize($files);
  $output = vec[];
  foreach ($files as $key => $value) {
    $output[] = tuple($key, $value);
  }

  return $output;
}
