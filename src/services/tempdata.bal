function __init () {
    Officer o;

    o = {
        uuid: "off1",
        idNumber: "795011234V",
        nameWithInitials: "A. X. Y. Panditha",
        dob: {
            year: 1979,
            month: 1,
            day: 11
        },
        gender: <Gender> "M",
        address: { 
            line1: "198/299 Watta Pahala Road",
            line2: "Kurunegala"
        },
        mobilePhone: "077-777-7777",
        homePhone: "008-111-2222",
        email: "panditha@kurunegalamail.lk",
        emergencyContact: {
            name: "A. B. Ifixstuff",
            phone: "033-333-3333"
        },
        pollingStationId: "FX-123",
        preferredDistrictIds: ["Kurunegala", "Kandy", "Chilaw", "Anuradhapura", "Gampaha"],
        position: {
            instituteUuid: "inst1-uuid",
            post: "Admin Officer Grade I",
            postNature: {
                fieldBased: true,
                officeBased: true
            },
            fieldOffice: "Kurunegala Mental Office",
            serviceName: "IT Service",
            serviceStartDate: {
                year: 2005,
                month: 8,
                day: 4
            },
            grade: "A1",
            salaryCode: "S1",
            basicMonthlySalary: 31500
        },
        previousPositions: [],
        previousDuties: [],
        politicallyExposed: true,
        politicalRole: "Agent",
        electionId: "1999-Parliamentary"
    };
    officers[o?.uuid ?: "XXXX"] = o;
    
    o = {
        uuid: "off2",
        idNumber: "6303651235v",
        nameWithInitials: "B. S. Podisingho",
        dob: {
            year: 1963,
            month: 12,
            day: 31
        },
        gender: <Gender> "F",
        address: { 
            line1: "19 Boru Para",
            line2: "Wattala"
        },
        mobilePhone: "077-777-6631",
        homePhone: "008-613-1361",
        email: "podisngiht@koskatta.lk",
        emergencyContact: {
            name: "X. DeadMan",
            phone: "033-901-6141"
        },
        pollingStationId: "AB-136",
        preferredDistrictIds: ["Matara", "Colombo", "Chilaw", "Jaffna", "Gampaha"],
        position: {
            instituteUuid: "inst1-uuid",
            post: "Technical Officer Grade I",
            postNature: {
                fieldBased: false,
                officeBased: true
            },
            serviceName: "Boru Service",
            serviceStartDate: {
                year: 1995,
                month: 1,
                day: 1
            },
            grade: "A3",
            salaryCode: "C5",
            basicMonthlySalary: 94000
        },
        previousPositions: [],
        previousDuties: [],
        politicallyExposed: false
    };    
    officers[o?.uuid ?: "XXXX"] = o;

    Institution i;

    i = {
        uuid: "inst1-uuid",
        name: "Angoda Mental Hospital",
        address: {
            line1: "1 Hondahitha Road",
            line2: "Angoda"
        },
        phone: "011-999-8888",
        fax: "011-999-8887",
        divisionalSecretariat: "Colombo That Side"
    };
    insts[i?.uuid ?: "YYYY"] = i;
    
    i = {
        uuid: "inst2-uuid",
        name: "Road Development Authority",
        address: {
            line1: "1 The Main Road",
            line2: "Colombo 00100"
        },
        phone: "011-111-9085",
        fax: "011-222-5646",
        divisionalSecretariat: "Colombo Central"
    };
    insts[i?.uuid ?: "YYYY"] = i;
}
