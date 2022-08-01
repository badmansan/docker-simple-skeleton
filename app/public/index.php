<?php

use Doctrine\Common\Collections\ArrayCollection;

require __DIR__ . '/../vendor/autoload.php';

// test autoload
$collection = new ArrayCollection(range(10, 15));
echo '<pre>' . print_r($collection->toArray(), TRUE) . '</pre>';

// test db
$pdo = new PDO('pgsql:host=db;port=5432;dbname=app_db', 'app_db_user', '123456');
$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
$stmt = $pdo->query('SELECT NOW()');
echo '<pre>Get date/time using database query...';
echo $stmt->fetchColumn() . '</pre>';

// test intl extension
$localeStr = 'uk-UA';
echo '<pre>' . 'Locale set to `' . $localeStr . '`...';
$locale = new Locale();
$isLocaleSetSuccess = $locale::setDefault($localeStr);
echo ($isLocaleSetSuccess ? 'success' : 'fail') . '</pre>';

phpinfo();
