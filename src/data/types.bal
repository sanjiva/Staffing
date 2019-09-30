public type Gender "M" | " F";

public type Date record {
    int year;
    int month;
    int day;
};

public type Address record {
    string line1;
    string line2;
};

public type Institution record {
    string id;
    string name;
    Address address;
    string phone;
    string fax;
    // what DS division does this institute belong to
    string divisionalSecretariat;
};

public type Job record {
    // which institution is the job in
    Institution institute;

    // job title and nature
    string post;
    record {
        boolean fieldBased;
        boolean officeBased;
    } postNature;
    // if field based job which field office
    string fieldOffice;

    // name of service to which post belongs
    string serviceName;

    // start date in the service
    Date serviceStartDate;
    string grade;
    string salaryCode;
    int basicMonthlySalary;
};

public type ElectionDutyRole "CL" | "JPO" | "AddlSPO" | "SPO" | "ARO" | "DCCO" | "CCO";

public type ElectionDuty record {
    string electionId;
    ElectionDutyRole role;

    // details of the role, depends on the role
    string pollingStationID?;
    boolean countingVotes?;
    boolean issuingReceivingBoxes?;
    boolean zonalARO?;
    string other?;
};

public type PoliticalRole "Candidate" | "Agent";

public type Officer record {
    // NIC or SLIN
    string idNumber;

    // personal info
    string nameWithInitials;
    Date dob;
    Gender gender;

    // contact info
    Address address;
    string mobilePhone;
    string homePhone;
    string email;
    record {
        string name;
        string phone;
    } emergencyContact;

    // ID of polling station for this person
    string pollingStationId;

    // up to 5 preferred districts for assignment (in order of pref)
    string[5] preferredDistrictIds;

    // work records, with most recent last (appended)
    Job[] jobs;

    // election duty history, with most recent last (appended)
    ElectionDuty[] previousDuties;

    // have you or your wife been actively engaged in politics in last election, 
    // and if so in what role and which election
    boolean policallyExposed;
    PoliticalRole politicalRole;
    string election;
};