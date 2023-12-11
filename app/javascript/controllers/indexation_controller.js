import {Controller} from "@hotwired/stimulus"
import {Modal} from "flowbite"

// Connects to data-controller="indexation"
export default class extends Controller {
    static targets = ["inputForm", "resultModal", "baseRent", "baseIndex", "currentIndex", "newRent", "errorDetails"]

    showErrorMessage(data) {
        this.errorDetailsTarget.textContent = data;
    }

    getIndexationData(jsonData) {
        const requestOptions = {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify((jsonData))
        }

        fetch("/api/v1/indexations", requestOptions)
            .then(response => {
                if (!response.ok) {
                    return response.json().then(data => {
                        throw data;
                    });
                }
                return response.json();
            }).then(data => {
            if (data) {
                console.log("Response data:", data);
                this.showResults(jsonData, data);
            }
        }).catch(error => {
            try {
                if (typeof error === 'object') {
                    if (error.error) {
                        this.showErrorMessage(error.error);
                    } else {
                        const jsonError = error.json();
                        console.log("Error details: ", jsonError);
                        for (const key in errorObject) {
                            if (errorObject.hasOwnProperty(key)) {
                                console.log(`Errors for ${key}:`);
                                for (const errorMessage of errorObject[key]) {
                                    console.log(`- ${errorMessage}`);
                                }
                            }
                        }
                        this.showErrorMessage(jsonError)
                    }
                }
            } catch (e) {
                console.log("No data received");
                this.showErrorMessage("No data has been received.")
            }
        })
    }

    onsubmit(event) {
        if (this.inputFormTarget.checkValidity()) {
            this.clearResult();
            let jsonData = {
                "start_date": this.inputFormTarget.start_date.value,
                "signed_on": this.inputFormTarget.signed_date.value,
                "base_rent": this.inputFormTarget.base_rent.value,
                "region": this.inputFormTarget.querySelector('input[name="region"]:checked')?.value,
                "current_date": this.inputFormTarget.current_date.value
            }

            console.log(jsonData);

            let jsonResult = this.getIndexationData(jsonData);
            console.log(jsonResult);
        } else {
            this.resultModal.hide();
            event.stopPropagation();
            console.log("Form invalid");
            const invalidFields = this.inputFormTarget.querySelectorAll(':invalid');

            invalidFields.forEach(field => {
                console.log(`Invalid field: ${field.name}`);
            });
            this.inputFormTarget.requestSubmit();
            return false;
        }
    }

    clearResult() {
        this.errorDetailsTarget.textContent = "";
        this.newRentTarget.textContent = "";
        this.baseIndexTarget.textContent = "";
        this.currentIndexTarget.textContent = "";
        this.resultModal.hide();
    }

    showResults(formData, apiResponse) {
        this.baseRentTarget.textContent = formData.base_rent;
        this.baseIndexTarget.textContent = apiResponse.base_index;
        this.currentIndexTarget.textContent = apiResponse.current_index;
        this.newRentTarget.textContent = apiResponse.new_rent;
        this.resultModal.show();
    }

    assignCurrentDate() {
        document.getElementById("current_date").valueAsDate = new Date();
    }

    clearCurrentDate() {
        document.getElementById("current_date").value = "";
    }

    connect() {
        this.resultModal = new Modal(this.resultModalTarget);
        console.log(`Connecting indexation to ${this.inputFormTarget}, ${this.inputFormTarget.checkValidity()}`);
    }
}
