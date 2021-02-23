const express = require( 'express' );
const app = express();
const bodyParser = require('body-parser');
const https = require('https')
const http = require('http');
const args = process.argv.slice(2) //Required to authenticate with Github action repo
const repoPath  = '/repos/f5devcentral/adpm-agility/dispatches'  //Modify to match designated github action repo
 
 /*  
 Create Listening server - receive alerts from analytics provider
 */

 http.createServer((request, response) => {
  if (request.method == 'POST') {

    const { headers, method, url } = request;
    let body = [];
    request.on('error', (err) => {
     console.error(err);
   
      }).on('data', (chunk) => {
      body.push(chunk);
      }).on('end', () => {
     body = Buffer.concat(body).toString();
     bodyJson = JSON.parse(body);
     source = bodyJson.source;
     scaleAction = bodyJson.scaleAction;
     //console.log(bodyJson);

     if (scaleAction == null){
        console.log("error with scaleaction");
        esponse.end();
      };

     if (source == "azureLogs"){
      analytic = "azure"
      vals = bodyJson.SearchResults.tables[0].rows[0].toString();
      var hostIndex = vals.search("bigip.azure")
      //hostName = vals.substring(hostIndex, hostIndex + 20)

      v = vals.split(",");
      hostName = v[1];
      poolName = v[0];

    } else if (source == 'elk') {
      analytic = "elk"
      hostName = bodyJson.hostName
      poolName = bodyJson.poolname
    }
    
     //Convert hostName and poolName to arrays and derive identifiers
     var n = hostName.split(".");
     student_id = n[2];

     //Create scaling eventtype
     var app_name = "";
     switch (scaleAction) {
       case "scaleOutBigip":
          what2Scale = 'bigip';
          scaling_direction = 'up'
          break;
      case "scaleInBigip":
          what2Scale = 'bigip';
          scaling_direction = 'down'
          break;
      case "scaleOutWorkload":
          what2Scale = 'app';
          scaling_direction = 'up'
          app_name = poolName.split("/");
          break;
      case "scaleInWorkload":
        what2Scale = 'app';
        scaling_direction = 'down'
        app_name = poolName.split("/");
          break;
     } 
    
    console.log("The Student ID is - " + student_id + ". Webhook request to scale the " + what2Scale + " " + scaling_direction + ".  If relevant, the app name is '" + poolName + "'.")    

    //Construct Github Action webhook payload
    const data2 = JSON.stringify({
        event_type: "scale-" + analytic,
        client_payload: {
            scaling_type: what2Scale,
            app_name: app_name[0],
            scaling_direction: scaling_direction,
            webhookSource: source,
            student_id: student_id
          }
        })

    const options = {
       hostname: 'api.github.com',
       port: 443,
       path: repoPath,
       method: 'POST',
       headers: {
         'Content-Type': 'application/json',
         'Content-Length': data2.length,
         'Authorization': 'token ' + args[0],
         'user-agent': 'node.js'
       }
    }
    
    /*
    Create https POST to github
    */
    const req2 = https.request(options, res2 => {
      console.log(`Post to Github returned status code of: ${res2.statusCode}`)
      console.log("Processing operation complete.\n")
     
       res2.on('data', d => {
         process.stdout.write(d)
       })
     })
     
     req2.on('error', error => {
       console.error(error)
     })
     
     // submit payload via webhook to Github Action
     req2.write(data2)
     
     req2.end()

     response.on('error', (err) => {
       console.error(err);
     });
 
     response.writeHead(200, {'Content-Type': 'application/json'})
 
     const responseBody = { headers, method, url, body };
 
     response.write(JSON.stringify(responseBody));
   
     response.end();
     });
    }
    else {
      response.end();
    }

  // Start listener
  console.log("Starting alert processor...\n")
  }).listen(8000);

