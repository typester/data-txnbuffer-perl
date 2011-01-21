use inc::Module::Install;
name 'Data-TxnBuffer';
all_from 'lib/Data/TxnBuffer.pm';
readme_from 'lib/Data/TxnBuffer.pm';

test_requires 'Test::More' => '0.88';
tests 't/*.t';
author_tests 'xt';

auto_set_repository;

WriteAll;
