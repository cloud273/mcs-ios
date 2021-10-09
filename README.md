# TESTFLIGHT

1. PATIENT APP: https://testflight.apple.com/join/65qySFEb

2. DOCTOR APP: https://testflight.apple.com/join/Gs69j8P5

# REMAIN

1. PATIENT APP

    + Show prescription
    
    + Prevent multi-booing on a day, on a doctor

    + Design and apply new design

    + Re-check everything before release
    

2. DOCTOR APP

    + Create custom schedule on a day

    + Prescription 

# IMPROVEMENT 



# NOTE

1. Git

    + `git clone --recurse-submodules https://cloud273.com:8027/mcs/ios.git`
    + `git pull --recurse-submodules`
    
2. Submodule

    + Add:  `git submodule add https://cloud273.com:8027/library/ios-core.git`
    + Add:  `git submodule add https://cloud273.com:8027/library/ios-localization.git`
    + Add:  `git submodule add https://cloud273.com:8027/library/ios-whiteLabel.git`
    
    +  Remove: 
        - `git submodule deinit <path_to_submodule>`
        - `git rm <path_to_submodule>`
        - `git commit-m "Removed submodule "`
        - `rm -rf .git/modules/<path_to_submodule>`

    + Update
        - `git pull origin HEAD:master`
        - `git push origin HEAD:master`


2. Convert p12 to pem to read information

    + `openssl pkcs12 -in doctor.p12 -out doctor.pem -nodes -clcerts`
    + `openssl pkcs12 -in patient.p12 -out patient.pem -nodes -clcerts`

