#!/bin/bash

#cpptestcli -exclude cpptest_custom_excludes.lst -include cpptest_custom_includes.lst -compiler gcc_13-64 -config "builtin://MISRA C++ 2023" -report MISRACPP2023-report -input build/compile_commands.json

#MISRA C++ 2023 static analysis for Iceoryx
#cpptestcli -module . -include "*/source/*.cpp" -include "*/source/*/*.cpp" -publish -property build.id=baseline -property dtp.project=iceoryx -compiler gcc_13-64 -config "builtin://MISRA C++ 2023" -report MISRACPP2023-report -input build/compile_commands.json
cpptestcli -module . -include "*/source/*.cpp" -include "*/source/*/*.cpp" -publish -property build.id=feature2 -property dtp.project=iceoryx -compiler gcc_13-64 -config "builtin://MISRA C++ 2023" -report MISRACPP2023-report -input build/compile_commands.json

#CERT C++ 2023 static analysis for Iceoryx
cpptestcli -module . -include "*/source/*.cpp" -include "*/source/*/*.cpp" -publish -property build.id=feature2 -property dtp.project=iceoryx -compiler gcc_13-64 -config "builtin://SEI CERT C++ Rules" -report CERTCPP-report -input build/compile_commands.json
#cpptestcli -module . -include "*/source/*/*.cpp" -publish -property build.id=feature1 -property dtp.project=iceoryx -compiler gcc_13-64 -config "builtin://SEI CERT C++ Rules" -report CERTCPP-report -input build/compile_commands.json

#Metrics
cpptestcli -module . -include "*/source/*.cpp" -include "*/source/*/*.cpp" -publish -property build.id=feature2 -property dtp.project=iceoryx -compiler gcc_13-64 -config "builtin://Metrics" -report METRICS-report -input build/compile_commands.json
#cpptestcli -module . -include "*/source/*.cpp" -include "*/source/*/*.cpp" -publish -property build.id=baseline -property dtp.project=iceoryx -compiler gcc_13-64 -config "builtin://Metrics" -report METRICS-report -input build/compile_commands.json

#CWE Top 25 + On the Cusp 2023 static analysis for Iceoryx
cpptestcli -module . -include "*/source/*.cpp" -include "*/source/*/*.cpp" -publish -property build.id=feature2 -property dtp.project=iceoryx -compiler gcc_13-64 -config "builtin://CWE Top 25 + On the Cusp 2023" -report CWE-report -input build/compile_commands.json
#cpptestcli -module . -include "*/source/*/*.cpp" -publish -property build.id=feature1 -property dtp.project=iceoryx -compiler gcc_13-64 -config "builtin://CWE Top 25 + On the Cusp 2023" -report CWE-report -input build/compile_commands.json

RET_CODE=$?

# Interpret return code
case $RET_CODE in
  0)
    echo "✅ cpptestcli - Successful completion."
    ;;
  130)
    echo "❌ Malformed command-line or resource not found."
    ;;
  131)
    echo "❌ Workspace is busy."
    ;;
  133)
    echo "❌ EULA not accepted. Check 'parasoft.eula.accepted' setting."
    ;;
  134)
    echo "❌ License problem encountered."
    ;;
  135)
    echo "❌ Process exited with an exception. Check error log."
    ;;
  136)
    echo "❌ Test configuration problem encountered."
    ;;
  137)
    echo "❌ Input scope error."
    ;;
  138)
    echo "❌ Compiler configuration error."
    ;;
  139)
    echo "❌ Rule configuration error."
    ;;
  140)
    echo "❌ Settings problem encountered."
    ;;
  33)  # 0x21
    echo "❌ Static analysis violations (with -fail switch)."
    ;;
  65)  # 0x41
    echo "❌ Unit test violations (with -fail switch)."
    ;;
  1025)  # 0x401
    echo "❌ Setup problems reported (requires 'cpptest.fail.setup.problems=true')."
    ;;
  *)
    echo "❌ Unknown error. Exit code: $RET_CODE"
    ;;
esac
