#!/bin/bash
export LC_ALL=C
export LANG=C

function bashunit()
{(
    function main()
    {
        _test_num=0
        _test_name=()
        _assert_ok_count_num=0
        _assert_ng_count_num=0
        _assert_ok_count_list=()
        _assert_ng_count_list=()

        echo ''
        echo "SHUnit 1.0.0"

        set_up_before
        if [ ${#} -eq 0 ];then
            while :;do
                _assert_ok_count=0
                _assert_ng_count=0

                _test_num=$((_test_num + 1))
                _test="test_${_test_num}"
                exec_test "${_test}"
                _assert_ok_count_list=(${_assert_ok_count_list[*]} ${_assert_ok_count})
                _assert_ng_count_list=(${_assert_ng_count_list[*]} ${_assert_ng_count})
            done
        else
            for _test in ${*};do
                _assert_ok_count=0
                _assert_ng_count=0

                _test_num=$((_test_num + 1))
                exec_test "${_test}"
                _assert_ok_count_list=(${_assert_ok_count_list[*]} ${_assert_ok_count})
                _assert_ng_count_list=(${_assert_ng_count_list[*]} ${_assert_ng_count})
            done
        fi
        echo " $(get_assert_count)"
        echo ''
        tear_down_after

        _message="(${_test_num} tests, $((${_assert_ok_count_num} + ${_assert_ng_count_num})) assertions, ${_assert_ng_count_num} failures)              "
        if [ ${_assert_ng_count_num} -eq 0 ];then
            echo -e "\033[0;37;42mOK ${_message}\033[0m"
        else
            echo -e "\033[0;37;41mNG ${_message}\033[0m"
        fi

        echo ''
        echo 'Test execution result.'
        _i=0
        for _x in ${_test_name[*]};do
            _message="($((${_assert_ok_count_list[${_i}]} + ${_assert_ng_count_list[${_i}]})) assertions, ${_assert_ng_count_list[${_i}]} failures)"
            if [ ${_assert_ng_count_list[${_i}]} -eq 0 ];then
                echo -e "  - ${_x}\t\t\033[0;32mOK\033[0m ${_message}"
            else
                echo -e "  - ${_x}\t\t\033[0;31mNG\033[0m ${_message}"
            fi
            _i=$((_i + 1))
        done

        return 0
    }

    function exec_test()
    {
        _test=${1}
        if ! type ${_test} > /dev/null 2>&1 $_test;then
            _test_num=$((_test_num - 1))
            break;
        fi

        set_up
        ${_test}
        tear_down

        #sleep 1s

        return 0
    }

    function get_assert_count()
    {
        echo "$((${_assert_ok_count_num} + ${_assert_ng_count_num}))"
    }

    function set_test_name()
    {
        _test_name=(${_test_name[*]} ${1})

        return $?
    }

    function assert()
    {
        if [ $(($(get_assert_count) % 50)) -eq 0 ];then
            if [ $(get_assert_count) -eq 0 ];then
                echo ''
            else
                echo " $(get_assert_count)"
            fi
        fi

        if [ ${1} -eq 0 ];then
            _assert_ok_count=$((_assert_ok_count + 1))
            _assert_ok_count_num=$((_assert_ok_count_num + 1))
            echo -n '.'
        else
            _assert_ng_count=$((_assert_ng_count + 1))
            _assert_ng_count_num=$((_assert_ng_count_num + 1))
            echo -n 'F'
        fi

        return $?
    }

    function assertEquals()
    {
        test "${1}" = "${2}" > /dev/null 2>&1
        assert $?

        return $?
    }

    function assertNotEquals()
    {
        test "${1}" != "${2}" > /dev/null 2>&1
        assert $?

        return $?
    }

    function assertTrue()
    {
        assertEquals ${1} 0

        return $?
    }

    function assertFalse()
    {
        assertNotEquals ${1} 0

        return $?
    }

    function assertFileExists()
    {
        test -f ${1} > /dev/null 2>&1
        assert $? "${1}"

        return $?
    }

    function assertFileNotExists()
    {
        test ! -f ${1} > /dev/null 2>&1
        assert $? "${1}"

        return $?
    }

    if [ "${1}" = "run" ];then
        main ${@:2:($#-1)}
        return $?
    fi

    return 0
)}

function set_up_before()
{
    return 0
}

function set_up()
{
    return 0
}

function tear_down()
{
    return 0
}

function tear_down_after()
{
    return 0
}
