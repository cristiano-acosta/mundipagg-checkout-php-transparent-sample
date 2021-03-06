

    <div class="demo-container">
      <div class="text-center">
        <img src="catalog/view/theme/default/image/logo-mundi.png"><br><br>
      </div>
      <div class="alert alert-success" style="display: none">
        <strong>Parabéns \o/</strong>
        <span id="alert-success-message"></span>
      </div>
      <div class="alert alert-danger" style="display: none">
        <strong>Oops =(</strong>
        <span id="alert-error-message"></span>
      </div>
      <div class="card-wrapper"></div>
      <div class="form-container active">
        <form>

          <input class="form-control" placeholder="Número do cartão" required="required" type="text" name="number" id="number">
          <input class="form-control" placeholder="Nome presente no cartão" required="required" type="text" name="name" id="name">
          <input class="form-control" placeholder="Validade do cartão" required="required" type="text" name="expiry" id="expiry">
          <input class="form-control" placeholder="Código de segurança" required="required" type="text" name="cvc" id="cvc">
          <input class="btn btn-success btn-block" type="submit">

        </form>
      </div>
    </div>
    <script type="text/javascript" src="catalog/view/javascript/payment/mundipagg/jquery.card.js"></script>
    <!--<script src="js/jquery.card.js"></script>-->
    <script>
      $(function(){
        $('form').card({
          // a selector or DOM element for the container
          // where you want the card to appear
          container:'.card-wrapper', // *required*
          // all of the other options from above
        });
        $("form").on("submit", function(event){

          // Configura a url
          //var confirmationUrl="https://checkoutstaging.mundipaggone.com/checkout/<?php echo $tokenResponse->TokenKey; ?>/confirm";
          var confirmationUrl="https://checkoutstaging.mundipaggone.com/checkout/<?php echo $TokenKey; ?>/confirm";
          console.log(confirmationUrl);
          // Workaround para obter a bandeira pela div exibida
          $(".jp-card-logo").each(function(index, item){
            if($(item).css('opacity') == 1) {
              brand=$(item).text();
              brand=brand.charAt(0).toUpperCase() + brand.slice(1).toLowerCase();
            }
          });
          console.log(brand);
          // Configura os parametros do request
          var confirmationData={
            "CreditCard[CreditCardNumber]":$("#number").val().replace(/\s+/g, ""),
            "CreditCard[ExpMonth]":$("#expiry").val().split(" / ")[0],
            "CreditCard[ExpYear]":$("#expiry").val().split(" / ")[1],
            "CreditCard[HolderName]":$("#name").val(),
            "CreditCard[Name]":brand,
            "CreditCard[SecurityCode]":$("#cvc").val(),
            "Options[IsCreditCardPaymentEnabled]":"true",
          };
          console.log(confirmationData);
          $(".alert").hide();
          $("input[type='submit']").attr("disabled", "disabled");
          // Dispara o request
          $.ajax({
            url:confirmationUrl, method:"POST", data:confirmationData
          }).done(function(response){
            console.log(response);
            if(response.Success) {
              $("#alert-success-message").html(response.TokenStatus).parent().show();
            } else {
              $("#alert-error-message").html(response.TokenStatus).parent().show();
            }
          }).error(function(jqXHR){
            console.log(jqXHR);
            $("#alert-error-message").html("Deu ruim.").parent().show();
          }).always(function(){
            $("input[type='submit']").removeAttr("disabled");
          });
          event.preventDefault();
        });
      });
    </script>
  </body>
</html>