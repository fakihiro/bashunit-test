#!/bin/bash
export LC_ALL=C
export LANG=C

function sample()
{
    function sample::main()
    {(
        echo ${FUNCNAME[0]}
        sample::sample1
        sample::sample2
        return $?
    )}

    function sample::sample1()
    {(
        echo ${FUNCNAME[0]}
        return $?
    )}

    function sample::sample2()
    {(
        echo ${FUNCNAME[0]}
        return $?
    )}

    return 0
}

if [ "${1}" = "run" ];then
    sample && sample::main ${@:2:($#-1)}
    exit $?
fi

