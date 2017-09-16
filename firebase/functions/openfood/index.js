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
exports.shortenUrl = functions.database.ref('/links/{linkID}').onWrite(event => {
    const String barcode = event.data;
if (typeof barcode.val() !== 'string') {
    return;
}
return getDataBasedOnBarcode(barcode);
});

// Request to Openfood based on
// https://www.openfood.ch/api-docs/swaggers/v3
function createOpenfoodRequest(barcode) {
    return {
        method: 'GET',
        uri: `https://www.openfood.ch/api/v3/products?barcodes=` + barcode,
        headers: {
            'Authorization': `Token token=${functions.config().openfood_apikey}`
        },
        json: true,
        resolveWithFullResponse: true
    };
}

function getDataBasedOnBarcode(barcode) {
    return request(createOpenfoodRequest(barcode)).then(response => {
        if (response.statusCode === 200) {
        return response.body;
    }
    throw response.body;
}).then(body => {
        return admin.database().ref(`/links/${key}`).set({
            body
        });
});
}