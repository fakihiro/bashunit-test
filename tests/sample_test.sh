#!/bin/bash
cd $(dirname $0)/../
export LC_ALL=C
export LANG=C

. ./bashunit.sh

. ./sample.sh

function set_up()
{
    sample
}

function test_1()
{
    set_test_name "sample::mainのテスト"

    sample::main > /dev/null 2>&1

    assertTrue $?
}

function test_2()
{
    set_test_name "sample::mainのテスト2"

    sample::main > /dev/null 2>&1

    assertTrue $?
}

function test_3()
{
    set_test_name "sample::sample1のテスト"

    assertNotEquals "sample::sample1" "$(sample::sample1)"
}

function test_4()
{
    set_test_name "sample::sample1の失敗テスト"

    assertEquals "sample::sample1" "$(sample::sample1)"
}

bashunit run ${*}
