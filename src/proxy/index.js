var debuggerURL = process.env.DEBUGGER_URL;
var proxyPort = process.env.PROXY_PORT;
var proxyResultDir = process.env.PROXY_RESULT_DIR;

var express = require('express');
var app = express();
var httpProxy = require('http-proxy');
var apiProxy = httpProxy.createProxyServer();
var log = require('intel');

log.addHandler(new log.handlers.File(proxyResultDir));
log.addFilter(new log.Filter(/.*d2p1:measure.*/));
var parseString = require('xml2js').parseString;


app.all("/*", function (req, res) {

    var jsonStringreq = '';
    req.on('data', function (data) {
        jsonStringreq += data;
    });

    req.on('end', function () {

        parseString(jsonStringreq, {trim: true, explicitArray:false}, function(err, result){
            log.info(JSON.stringify(result));
        });
      
        // log.info(jsonStringreq);
        // log.info(req.originalUrl);
        // log.info(req.headers);

    });
 
    apiProxy.web(req, res, { target: debuggerURL });

});

app.listen(proxyPort);