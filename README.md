# Content

- This repository includes coding for both Patient and Doctor application

- Patient can install app via https://testflight.apple.com/join/65qySFEb

- Doctor can install app via https://testflight.apple.com/join/Gs69j8P5

# Patient app

1. Account: Patient have his/her account, so he/she can follow his/her appointment and result
    - Create account using email
    - Update patient profile (name, date of birth, address, image ...)
    
2. Health information: Patient can input his/her health information so that he/she can send it to doctor when doing an appointment. This includes:
    - Create/update patient allergy information
    - Create/update patient surgery information
    - Update patient medication information (High blood pressure?, High cholesterol?, Pregnant?)
    
3. Booking an appointment
    - 

# Development

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

