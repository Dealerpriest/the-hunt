Parse.Cloud.define("checkCatchStatus", async (request) => {
  console.log(request);
})

Parse.Cloud.afterSave('Location', (request) => {
  console.log('new location received:', request);
})