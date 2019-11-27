@chcp 65001
call env.bat
start "" %v8path%dbgs.exe -a %1COVERAGE_DEBUG_HOST% -p %1COVERAGE_DEBUG_PORT%
start npm start
start "" %v8path%1cv8.exe DESIGNER /IBConnectionString%IBConnectionString% /debug -http -attach /debuggerURL%PROXY_URL% /AppAutoCheckMode
