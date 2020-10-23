const admin = require('firebase-admin')
const functions = require('firebase-functions')
admin.initializeApp(functions.config().firebase);

const defaultConfig = require('./defaultConfig');
const onUserUpdated = require('./onUserUpdated');
const onHalaqaUpdated = require('./onHalaqaUpdated');
const onCenterUpdated = require('./onCenterUpdated');
const onCenterJoinRequestCreated = require('./onCenterJoinRequestCreated');
const onRequestApproved = require('./onRequestApproved');
const onInstanceCreated = require('./onInstanceCreated');
const onMessageCreated = require('./onMessageCreated');


//admin
//exports.defaultConfig = defaultConfig.defaultConfig;
exports.onUserUpdated = onUserUpdated.onUserUpdated;
exports.onHalaqaUpdated = onHalaqaUpdated.onHalaqaUpdated;
exports.onCenterUpdated = onCenterUpdated.onCenterUpdated;
exports.onCenterJoinRequestCreated = onCenterJoinRequestCreated.onCenterJoinRequestCreated;
exports.onRequestApproved = onRequestApproved.onRequestApproved;
exports.onInstanceCreated = onInstanceCreated.onInstanceCreated;
exports.onMessageCreated = onMessageCreated.onMessageCreated;


