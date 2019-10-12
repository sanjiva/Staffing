import ballerina/http;
import ballerina/system;

map<Officer> officers = {};

@http:ServiceConfig {
    basePath: "/officer"
}
service OfficerService on staffServer {

    @http:ResourceConfig {
        methods: ["POST"],
        path: "/",
        body: "officer"
    }
    resource function add (http:Caller caller, http:Request req, Officer officer) returns error? {
        // add an officer
        string newUUID = addOfficer(<@untainted> officer);

        // TODO send back the created officer's ID as a Location: header and in payload
        check caller->created("/officer/" + newUUID, 
            { "uuid": newUUID, "name": <@untainted> officer.nameWithInitials });
    }

    @http:ResourceConfig {
        methods: ["GET"],
        path: "/{uuid}"
    }
    resource function get (http:Caller caller, http:Request req, string uuid) returns error? {
        Officer? i = findOfficer(<@untainted>uuid);
        if (i is Officer) {
            json j = check json.constructFrom(i);
            check caller->respond(j);
        } else {
            http:Response hr = new;
            hr.statusCode = 404;
            check caller->respond(hr);
        }
    }

    @http:ResourceConfig {
        methods: ["DELETE"],
        path: "/{uuid}"
    }
    resource function remove (http:Caller caller, http:Request req, string uuid) returns error? {
        if (removeOfficer(<@untainted>uuid)) {
            check caller->respond (<json>{"uuid": <@untainted>uuid});
        } else {
            http:Response hr = new;
            hr.statusCode = 404;
            check caller->respond(hr);
        }
    }

    @http:ResourceConfig {
        methods: ["PUT"],
        path: "/{uuid}",
        body: "officer"
    }
    resource function update (http:Caller caller, http:Request req, string uuid, Officer officer) returns error? {
        // uuid in path must be same as in the officer
        if (uuid != officer?.uuid) {
            http:Response hr = new;
            hr.statusCode = 400;
            hr.setJsonPayload (<json> { message: "Mismatched UUIDs: payload UUID does not match UUID in path"});
            return caller->respond(hr);
        }

        if (updateOfficer(<@untainted>officer)) {
            return caller->respond (<json>{"uuid": <@untainted>uuid});
        } else {
            http:Response hr = new;
            hr.statusCode = 404;
            return caller->respond(hr);
        }
    }
}

function addOfficer (Officer officer) returns string {
    string newUUID = system:uuid();
    officer.uuid = newUUID;
    officers[newUUID] = officer;
    return newUUID;
}

function findOfficer (string uuid) returns Officer? {
    if (officers.hasKey (uuid)) {
        return officers.get (uuid);
    } else {
        return ();
    }
}

function removeOfficer (string uuid) returns boolean {
    if (officers.hasKey (uuid)) {
        _ = officers.remove (uuid);
        return true;
    } else {
        return false;
    }
}

function updateOfficer (Officer officer) returns boolean {
    // must exist to update
    string u = officer?.uuid ?: ""; // should not happen
    if (officers.hasKey (u)) {
        officers[u] = officer;
        return true;
    } else {
        return false;
    }
}
