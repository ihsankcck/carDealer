function sendMessage(event) {
  var form = event.target;
  var elements = form.elements;
  var params = {
    first_name: elements.first_name.value,
    last_name: elements.last_name.value,
    mail: elements.mail.value,
    phone: elements.phone.value,
    message: elements.message.value,
    type: "contact",
  };

  fetch("/form", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(params),
  }).then(function (response) {
    response.json().then(function (data) {
      alert(data.message);
      form.reset();
    });
  });

  event.preventDefault();
  return false;
}
