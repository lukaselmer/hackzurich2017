/**
 * Fetches Data from Openfood based on the gien barcode string
 *
 */
'use strict';

const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);
const request = require('request-promise');

// Extract Data from Write
exports.openfood_fetcher = functions.database.ref('/barcodes/{barcode}').onWrite(event => {
    if (event.data.previous.exists()) {
        return null;
    }

    const barcode = event.data.val() + ""; //to declare value as string - type unsafe language :(
    if (typeof barcode !== 'string') {
        return null;
    }
    return getDataBasedOnBarcode(barcode);
});

// Request to Openfood based on
// https://www.openfood.ch/api-docs/swaggers/v3
function createOpenfoodRequest(barcode) {
    let tokenAsString = `Token token=\"${functions.config().openfood.apikey}\"`;
    return {
        method: 'GET',
        uri: `https://www.openfood.ch/api/v3/products?barcodes=` + barcode,
        headers: {
            'Authorization': tokenAsString
        },
        json: true,
        resolveWithFullResponse: true
    };
}

function getDataBasedOnBarcode(barcode) {
    console.log("value to lookup:" + barcode)
    return request(createOpenfoodRequest(barcode)).then(response => {
        if (response.statusCode === 200) {
            return response.body;
        }
        throw response.body;
    }).then(body => {
        let path = `/barcodes/`+barcode;
        return admin.database().ref(path).set({
            body
        });
    });
}
