# Headingsmovin_indexation_rails

This project provides the answer to the test requirements in a Rails project.

> This is not the desired platform for a solution, there is a Sinatra
> solution for this.

The project uses `Ruby 3.2.0` and `Rails 7.1.2`.

The Rails app, for the most part is a normal, vanilla Rails application.  It includes the API and a UI too.

## The API
The API is accessible on `/api/v1/indexations.` It will accept GET and POSTs on the above address.

You can POST the following JSON to the `/api/v1/indexations` endpoint:

`{
"start_date": "2010-09-01",
"signed_on": "2010-07-25",
"current_date": "2020-01-01",
"base_rent": "500",
"region": "brussels"
}`

`current_date` is optional, it can be used to prove the results match the supplied request, or for other historical data.
> It can be ommitted, in which case `today` is used

You can GET the following request to receive the same behaviour:

    /api/v1?start_date=01/01/2001&signed_date=10/01/2001&base_rent=7576&region=brussels

You will receive the following response:

    {
      "new_rent": 584.18, 
      "base_index": 112.74, 
      "current_index": 131.72
    } 

### Error Responses
If the external service is not available:

    {  "error": "[Base|Current} health-index cannot be calculated with 2021-12-01-1998: External service not available" }

If the supplied data does not resolve to a viable health-index from the service provider, for either of the indices, you will receive:

    {  "error": "[Base|Current] health-index cannot be calculated with 2021-12-01-1998: No data available" }

Badly formatted JSON on the body will give this response:

    {  "error": "Error occurred while parsing request parameters" }

Parameter errors will look like this:

Unexpected parameters will be rejected
Missing parameters will be rejected

    { "error": "found unpermitted parameter: :current_daate" }

    {  "error": "param is missing or the value is empty: start_date" }

Validation errors will follow this pattern:

    {
    "start_date": [ "invalid" ],
    "signed_on": [ "invalid" ]
    }

## The Front End
The UI is implemented using the new Rails tech-stack.  It is a Stimulus project using Tailwind CSS and Flowbite styling.
It presents the form and delivers the result in a modal in the layout requested.
It is delivered as the home-page of the site, so just visit `'/'`

