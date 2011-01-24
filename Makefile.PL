use inc::Module::Install;
name 'Data-TxnBuffer';
all_from 'lib/Data/TxnBuffer.pm';
readme_from 'lib/Data/TxnBuffer.pm';

requires 'Try::Tiny';

test_requires 'Test::More' => '0.88';
tests 't/*.t';
author_tests 'xt';

auto_set_repository;

if (want_xs()) {
    use_ppport 3.19;
    cc_src_paths 'src';

    # repeat testing
    # see also ExtUtils::MM_Any::test_via_harness()
    my $test_pp = q{$(FULLPERLRUN) -MExtUtils::Command::MM -e}
                    .q{ "do 't/force_pp.pl'; test_harness($(TEST_VERBOSE), '$(INST_LIB)', '$(INST_ARCHLIB)')"}
                    .q{ $(TEST_FILES)} . "\n";

    postamble qq{test_dynamic :: pp\n\n}
            . qq{pp ::\n}
            . qq{\t} . $test_pp;
}

WriteAll;
