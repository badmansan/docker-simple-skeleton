<?php

use Doctrine\Common\Collections\ArrayCollection;

require __DIR__ . '/../vendor/autoload.php';

// os version
exec('cat /etc/*-release', $result);
echo 'System: <pre>' . implode(PHP_EOL, $result) . '</pre>';

// test autoload
$collection = new ArrayCollection(range(10, 15));
echo '<br><pre>' . implode(',', $collection->toArray()) . '</pre>';

// test db
$pdo = new PDO('pgsql:host=db;port=5432;dbname=app_db', 'app_db_user', '123456');
$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
$stmt = $pdo->query('SELECT NOW()');
echo '<br><pre>Get date/time using database query...';
echo $stmt->fetchColumn() . '</pre>';

// test intl extension
$localeStr = 'uk-UA';
echo '<br><pre>' . 'Locale set to `' . $localeStr . '`...';
$locale = new Locale();
$isLocaleSetSuccess = $locale::setDefault($localeStr);
echo ($isLocaleSetSuccess ? 'success' : 'fail') . '</pre>';

phpinfo();
