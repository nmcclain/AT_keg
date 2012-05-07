<?php

$w = fetch_wikidata();
if (isset($w['error'])) { die('error parsing wiki: '.$w['error']); }
$a = fetch_arduinodata();
if (isset($a['error'])) { die('error parsing arduino data'); }

$d = array();
$d['left'] = array_merge($w['left'], $a['left']);
$d['right'] = array_merge($w['right'], $a['right']);

echo(json_encode($d))."\n";

exit(0);

#####################
function fetch_wikidata() {
  // fetch the kegorator wiki page
  $url = "http://wiki.atrust.com/index.php?n=LocalCustoms.MyATEKegerator";
  $content = `wget -q -O - $url`;
  $out = array();

  // find the table of keg data
  if (!preg_match("/Currently on Tap(.*)Please edit this table carefully/msU", $content, $matches)) {
    $out['error'] = 'Error parsing keg table';
    return $out;
  } 
  $table = preg_replace('/,/', ' ', $matches[1]);

  // find the keg names
  if (!preg_match("/<tr ><td  align='center'>Name<\/td><td  align='center'>(.*)<\/td><td  align='center'>(.*)<\/td><\/tr>/", $table, $matches)) {
    $out['error'] = 'Error parsing keg names';
    return $out;
  } 
  $k1name=$matches[1];
  $k2name=$matches[2];

  // find the keg descriptions
  if (!preg_match("/<tr ><td  align='center'>Description<\/td><td  align='center'>(.*)<\/td><td  align='center'>(.*)<\/td><\/tr>/", $table, $matches)) {
    $out['error'] = 'Error parsing keg descriptions';
    return $out;
  } 
  $k1desc=$matches[1];
  $k2desc=$matches[2];

  // find the brewers
  if (!preg_match("/<tr ><td  align='center'>Brewer<\/td><td  align='center'>(.*)<\/td><td  align='center'>(.*)<\/td><\/tr>/", $table, $matches)) {
    $out['error'] = 'Error parsing keg brewers';
    return $out;
  } 
  $k1brewer=$matches[1];
  $k2brewer=$matches[2];

  // find the abv
  if (!preg_match("/<tr ><td  align='center'>ABV<\/td><td  align='center'>(.*)<\/td><td  align='center'>(.*)<\/td><\/tr>/", $table, $matches)) {
    $out['error'] = 'Error parsing keg ABV';
    return $out;
  } 
  $k1abv=$matches[1];
  $k2abv=$matches[2];

  // find the type
  if (!preg_match("/<tr ><td  align='center'>Type<\/td><td  align='center'>(.*)<\/td><td  align='center'>(.*)<\/td><\/tr>/", $table, $matches)) {
    $out['error'] = 'Error parsing keg types';
    return $out;
  } 
  $k1type=$matches[1];
  $k2type=$matches[2];

  $out['left'] = array(
    'name' => $k1name,
    'brewer' => $k1brewer,
    'description' => $k1desc,
    'abv' => $k1abv,
    'type' => $k1type,
  );
  $out['right'] = array(
    'name' => $k2name,
    'brewer' => $k2brewer,
    'description' => $k2desc,
    'abv' => $k2abv,
    'type' => $k2type,
  );
  return $out;
}

#####################
function fetch_arduinodata() {

  $url = "http://bull.atrust.com/kegbot/check.php";
  $content = `wget -q -O - $url`;
  $out = array();

  # temp0,temp2,%remaining_left_side,%remaining_right_side | 34.59,40.21,53.25,99.95,881
  $parts = preg_split('/,/', $content);

  $out['left'] = array(
    'tempF' => $parts[0],
    'pctremaining' => $parts[2],
  );
  $out['right'] = array(
    'tempF' => $parts[1],
    'pctremaining' => $parts[3],
  );
  return $out;
}


