export const etsiStation = () => {
    return `<!--<div class="wrapper">-->
  <!-- "copyright: Copyright Nokia 2020 -->
  <div style="display: none;">
    Async ANSI Station template
  </div>
  <div class="col-half column-border disabled">
    <div class="label-top">MSS</div>
    <div class="col-half">
      <div id="tmpl-mss"></div>

      <!-- <label for="tmpl-coreprotection"></label> -->
      <!-- <div class="spacer-10"></div> -->
    </div>
    <!--
            COLUMN
        -->
    <div class="col-half">
      <select id="tmpl-corecard"></select>
      <div id="tmpl-coreprotection"></div>
    </div>
  </div>
  <!--
          COLUMN
        -->
  <div class="col-half column-border disabled">
    <!-- <label for="tmpl-logic-tester"></label> -->
    <!-- <div id="tmpl-logic-tester"></div> -->

    <!-- <div style="margin: 5px 0px;"><strong>Indoor features:</strong></div> -->
    <div class="label-top">Indoor features</div>

    <div id="tmpl-packet"></div>

    <!-- <label for="tmpl-synchro-in-out"></label> -->
    <div id="tmpl-synchro-in-out"></div>

    <!-- <label for="tmpl-1588"></label> -->
    <div class="align-children-horizontally">
      <div style="margin-right: 10px" id="tmpl-1588"></div>
      <label class="label-inline" for="tmpl-tc"></label>
      <select style="margin-right: 10px; margin-bottom: 0" id="tmpl-tc"></select>
      <label for="tmpl-sfp-tod"></label>
      <div id="tmpl-sfp-tod"></div>
    </div>

    <!-- <label for="tmpl-bandwidth-notification"></label> -->
    <div id="tmpl-bandwidth-notification"></div>

    <!-- <label for="tmpl-layer-3-vpn"></label> -->
    <div id="tmpl-layer-3-vpn"></div>

    <!-- <label for="tmpl-netconf"></label> -->
    <div id="tmpl-netconf"></div>

    <!-- <label for="tmpl-synchronous-ethernet"></label> -->
    <div id="tmpl-synchronous-ethernet"></div>
  </div>
  <!-- </div> -->

  <div style="display: none; position:fixed; top: 10px; left: 10px;">
    <button id="js-save-solution-to-ls">Save Solution to LS</button>
    <br><br>
    <button id="js-restore-solution-from-ls">Restore Solution from LS</button>
  </div>
<!--</div>-->
`;

}
