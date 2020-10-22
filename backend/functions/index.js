const admin = require('firebase-admin')
const functions = require('firebase-functions')
admin.initializeApp(functions.config().firebase);

const defaultConfig = require('./defaultConfig');
const onUserUpdated = require('./onUserUpdated');
const onHalaqaUpdated = require('./onHalaqaUpdated');
const onCenterUpdated = require('./onCenterUpdated');


//admin
//exports.defaultConfig = defaultConfig.defaultConfig;
exports.onUserUpdated = onUserUpdated.onUserUpdated;
exports.onHalaqaUpdated = onHalaqaUpdated.onHalaqaUpdated;
exports.onCenterUpdated = onCenterUpdated.onCenterUpdated;


