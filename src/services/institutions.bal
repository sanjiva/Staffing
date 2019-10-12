import ballerina/http;
import ballerina/system;

map<Institution> insts = {};

@http:ServiceConfig {
    basePath: "/institutions"
}
service InstitutionsService on staffServer {
    @http:ResourceConfig {
        methods: ["GET"],
        path: "/"
    }
    resource function listAll (http:Caller caller, http:Request req) returns error? {
        // return list of institution (name, UUID) pairs
        json[] list = getInstitutions();
        check caller->ok(<json>list);
    }
}

@http:ServiceConfig {
    basePath: "/institution"
}

service InstitutionService on staffServer {
    @http:ResourceConfig {
        methods: ["POST"],
        path: "/",
        body: "inst"
    }
    resource function add (http:Caller caller, http:Request req, Institution inst) returns error? {
        // save institution - safe to untaint since it's coming via secured endpoint
        string newUUID = addInstitution(<@untainted> inst);

        // TODO send back the created institution's ID as a Location: header and in payload
        check caller->created("/institution/" + newUUID, 
            { "uuid": newUUID, "name": <@untainted> inst.name });
    }

    @http:ResourceConfig {
        methods: ["GET"],
        path: "/{uuid}"
    }
    resource function get (http:Caller caller, http:Request req, string uuid) returns error? {
        Institution? i = findInstitution(<@untainted>uuid);
        if (i is Institution) {
            json j = check json.constructFrom(i);
            check caller->ok (j);
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
        if (removeInstitution(<@untainted>uuid)) {
            check caller->ok (<json>{"uuid": <@untainted>uuid});
        } else {
            http:Response hr = new;
            hr.statusCode = 404;
            check caller->respond (hr);
        }
    }

    @http:ResourceConfig {
        methods: ["PUT"],
        path: "/{uuid}",
        body: "inst"
    }
    resource function update (http:Caller caller, http:Request req, string uuid, Institution inst) returns error? {
        // uuid in path must be same as in the instutition
        if (uuid != inst?.uuid) {
            http:Response hr = new;
            hr.statusCode = 400;
            hr.setJsonPayload (<json> { message: "Mismatched UUIDs: payload UUID does not match UUID in path"});
            return caller->respond (hr);
        }

        if (updateInstitution(<@untainted>inst)) {
            return caller->ok (<json>{"uuid": <@untainted>uuid});
        } else {
            http:Response hr = new;
            hr.statusCode = 404;
            return caller->respond (hr);
        }
    }

    // Get all the officers of a particular insitution
    @http:ResourceConfig {
        methods: ["GET"],
        path: "/{uuid}/officers"
    }
    resource function getOfficers (http:Caller caller, http:Request req, string uuid) returns error? {
        // return all officers where officer.insitutionUUID == uuid
        json[] ofs = [];
        officers.forEach(function (Officer of) { 
            if (of.position.instituteUuid == uuid) { 
                ofs.push (checkpanic json.constructFrom (of)); // panic can't happen
            }
        });
        return caller->ok (<json>ofs);
    }

    // Bulk add officers to an organization
    @http:ResourceConfig {
        methods: ["POST"],
        path: "/{uuid}/officers",
        body: "ofs"
    }
    resource function addOfficers (http:Caller caller, http:Request req, string uuid, Officer[] ofs) returns error? {
        // Assumption: all officers' currentjob's institution uuid == uuid
        json[] officerUUIDs = [];
        // give UUIDs to every officer and save
        ofs.forEach(function (Officer x) { 
            string officerUUID = system:uuid();
            x.uuid = officerUUID;
            officers[officerUUID] = x;
            officerUUIDs.push (officerUUID);
        });
        return caller->ok (<json>officerUUIDs);
    }
}

function getInstitutions () returns json[] {
    // return list of institution (name, UUID) pairs
    json[] list = [];
    foreach var i in insts {
        list.push (<json>{ name: i.name, uuid: i?.uuid });
    }
    return  list;
}

function addInstitution (Institution inst) returns string {
    string newUUID = system:uuid();
    inst.uuid = newUUID;
    insts[newUUID] = inst;
    return newUUID;
}

function findInstitution (string uuid) returns Institution? {
    if (insts.hasKey (uuid)) {
        return insts.get (uuid);
    } else {
        return ();
    }
}

function removeInstitution (string uuid) returns boolean {
    if (insts.hasKey (uuid)) {
        _ = insts.remove (uuid);
        return true;
    } else {
        return false;
    }
}

function updateInstitution (Institution inst) returns boolean {
    // must exist to update
    string u = inst?.uuid ?: ""; // should not happen
    if (insts.hasKey (u)) {
        insts[u] = inst;
        return true;
    } else {
        return false;
    }
}