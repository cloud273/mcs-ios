# Content

- This repository includes coding for both Patient and Doctor application

- Patient can install app via https://testflight.apple.com/join/65qySFEb

- Doctor can install app via https://testflight.apple.com/join/Gs69j8P5

# Patient app

1. Account: Every patient has've got an account, so they can manage their profile, health information, appointment and result
    - Create account using email
    - Update patient profile (name, date of birth, address, image ...)
    
2. Health information: Patient can update their health information so that they can share them to doctor when create an booking. This includes:
    - Create/update patient's allergy information
    - Create/update patient's surgery information
    - Update patient's medication information (High blood pressure?, High cholesterol?, Pregnant?)
    
3. Booking an appointment: Patient can choose doctor and create an appointment with him/her
    - Select specialty
    - Search for doctor
    - Get booking fee
    - Select booking time
    - Cancel a booking
    
4. History of appointments

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

