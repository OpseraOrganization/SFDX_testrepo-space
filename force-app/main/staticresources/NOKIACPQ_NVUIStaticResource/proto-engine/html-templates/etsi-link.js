export const etsiLink = () => {
  return `<!-- Copyright Nokia 2020 -->
<div>Async ETSI link template</div>
<div class="container tmpl-tabs">
  <div class="row">
    <div class="tmpl-tab-show-all">All</div>
    <div class="tmpl-tab">Configuration</div>
    <div class="tmpl-tab">Frequency</div>
    <div class="tmpl-tab">Antenna</div>
    <div class="tmpl-tab">Connectivity</div>
  </div>
</div>


<div class="tmpl-pane">
  <div class="my-row column-border">
    <label for="" class="label-top">Configuration</label>
    <div class="col-one-third">
      <label class="label-gray--large" for="tmpl-ubt">UBT type</label>
      <select id="tmpl-ubt"></select>
    </div>

    <div class="col-one-third dropdownWidth">
      <label class="label-gray--large" for="tmpl-ubt">Radio configuration</label>
      <select id="tmpl-radio-configuration"></select>
    </div>

    <div class="col-one-third polarizationWidth">
      <label class="label-gray--large" for="tmpl-polarization">Polarization</label>
      <select id="tmpl-polarization"></select>
    </div>
  </div>

  <div class="spacer-15"></div>
  <div class="spacer-15"></div>

  <!-- CAPACITY/RADIO FEATURES ROW -->
  <div class="col-three-fifths column-border" style="height: 258px;">
    <label class="label-top" for="">Capacity license (per UBT)</label>
    <div class="reserve-space font-size-13px" id="tmpl-show-2nd-ubt-capacity" style="font-size: 13px;"></div>
    <dic class="row">
      <div class="col-half">
        <!-- <div class="reserve-space"></div> -->
        <select id="tmpl-ubt1-capacity"></select>
      </div>

      <div class="col-half">
        <!--<label class="label-top" style="font-size: 13px!important;" for="show-2nd-ubt-capacity"></label>-->


        <select id="tmpl-ubt2-capacity"></select>
      </div>
    </dic>

  </div>

  <div class="col-two-fifths column-border" style="height: 258px;">
    <!-- <div class="reserve-space"></div> -->
    <label class="label-top" for="tmpl-xpic">Radio features</label>
    <!-- <label for="tmpl-carrier-aggregation"></label> -->
    <div class="reserve-space" id="tmpl-carrier-aggregation"></div>

    <!-- <label for="tmpl-xpic"></label> -->
    <div class="reserve-space" id="tmpl-xpic"></div>

    <!-- <label for="tmpl-adaptive-modulation"></label> -->
    <div class="reserve-space" id="tmpl-adaptive-modulation"></div>

    <!-- <label for="tmpl-hqam"></label> -->
    <div class="reserve-space" id="tmpl-hqam"></div>

    <!-- <label for="tmpl-hqam-e-band"></label> -->
    <div class="reserve-space" id="tmpl-hqam-e-band"></div>

    <!-- <label for="tmpl-channel-spacing-500-mhz"></label> -->
    <div class="reserve-space" id="tmpl-channel-spacing-500-mhz"></div>
  </div>

  <div class="spacer-15"></div>
    <!-- END OF CAPACITY/RADIO FEATURES ROW -->
</div>


<div class="container tmpl-pane">
  <!-- UBT 1: -->
  <h4>UBT 1:</h4>
  <div class="row pane-border"><!-- ROW CONTAINING BOTH MAIN COLS -->
    <div class="col-md-2">
      <label for="tmpl-tx1-frequency">Frequency:</label>
      <select id="tmpl-tx1-frequency"></select>
    </div>

    <!-- SECOND WIDE COLUMN -->
    <div class="col-md-10" >
      <div class="row">
        <div class="col-md-12">

          <div class="row">
            <div class="col-md-3 shifter" style="padding-left: 30px">
              <label for="tmpl-shifter-tx1">Shifter:</label>
              <select id="tmpl-shifter-tx1"></select>
            </div>

            <div class="col-md-9" style="padding-left: 25px">
              <label for="tmpl-subband-tx1">Subband:</label>
              <select id="tmpl-subband-tx1"></select>
            </div>
          </div><!--row -->

          <div class="row">
            <div class="col-md-12">
              <label for="tmpl-show-2nd-transceiver-settings"></label>
              <div style="margin: 15px 15px;" id="tmpl-show-2nd-transceiver-settings"></div>
            </div>
          </div>

          <div id="tmpl-show-2nd-transceiver-settings-div" class="row">
              <div class="col-md-3 shifter">
                <label for="tmpl-shifter-tx2">Shifter2:</label>
                <select id="tmpl-shifter-tx2"></select>
              </div>

              <div class="col-md-9">
                <label for="tmpl-subband-tx2">Subband:</label>
                <select id="tmpl-subband-tx2"></select>
              </div>
          </div>

          <div class="row">
            <div class="col-xs-12">
              <div id="tmpl-subband-high-low-hide">
                <div class="spacer-20"></div>
                <!--<label for="tmpl-subband-station-selector">Station 1 / Station 2:</label>-->
                <label style="margin-bottom: 5px;" for="tmpl-subband-station-selector">
                  <span class="station1name"></span> /
                  <span class="station2name"></span> :
                </label>
                <div id="tmpl-subband-station-selector"></div>
              </div>
            </div>
          </div>

        </div>
      </div>

    </div><!-- RIGHT COL END -->

    <div class="col-xs-4">
      <div class="row">
        <br>
          <!-- <div class="col-xs-6">
            <span>Station 1:</span>
          </div>

          <div class="col-xs-6">
            <span>Station 2:</span>
          </div> -->
      </div>


    </div>
  </div><!-- END OF ROW CONTAINING BOTH MAIN COLS -->


  <label for="tmpl-show-2nd-ubt-frequency-settings"></label>
  <div class="reserve-space" style="margin: 7px 0;" id="tmpl-show-2nd-ubt-frequency-settings"></div>
  <!-- UBT 2: -->
  <div id="ubt2-div-js">
    <h4>UBT 2:</h4>
    <div class="row pane-border"><!-- ROW CONTAINING BOTH MAIN COLS -->
      <div class="col-md-2">
        <label for="tmpl-tx3-frequency">Frequency:</label>
        <select id="tmpl-tx3-frequency"></select>
      </div>

      <!-- SECOND WIDE COLUMN -->
      <div class="col-md-10" style="padding-left: 30px">
        <div class="row">
          <div class="col-md-12">

            <div class="row">
              <div class="col-md-3 shifter">
                <label for="tmpl-shifter-tx3">Shifter:</label>
                <select id="tmpl-shifter-tx3"></select>
              </div>

              <div class="col-md-9">
                <label for="tmpl-subband-tx3">Subband:</label>
                <select id="tmpl-subband-tx3"></select>
              </div>
            </div><!--row -->

            <div class="row">
              <div class="col-md-12">
                <label for=""></label>
                <div style="margin: 15px 0;" id="tmpl-show-2nd-transceiver-settings"></div>
              </div>
            </div>

            <div class="row">
                <div class="col-md-3 shifter">
                  <label for="tmpl-shifter-tx4">Shifter:</label>
                  <select id="tmpl-shifter-tx4"></select>
                </div>

                <div class="col-md-9">
                  <label for="tmpl-subband-tx4">Subband:</label>
                  <select id="tmpl-subband-tx4"></select>
                </div>
            </div>

            <!-- <div class="row">
              <div class="col-xs-12">
                <div>
                  <br>
                  <label for="tmpl-subband-station-selector">Station 1 / Station 2:</label>
                  <div id="tmpl-subband-station-selector"></div>
                </div>
              </div>
            </div> -->

          </div>
        </div>

      </div><!-- RIGHT COL END -->

      <div class="col-xs-4">
        <div class="row">
          <br>
            <!-- <div class="col-xs-6">
              <span>Station 1:</span>
            </div>

            <div class="col-xs-6">
              <span>Station 2:</span>
            </div> -->
        </div>


      </div>

    </div><!-- END OF ROW CONTAINING BOTH MAIN COLS -->
  </div>
  </div><!-- END OF FREQUENCY SUBBAND PANE -->

<!-- ANTENNA TAB -->
<div class="tmpl-pane">
  <!-- <h4>Antenna </h4> -->
  <div class="my-row">
    <label class="label-middle">Antenna for:</label>

    <div class="col-half column-border">
      <label class="label-top station1name"></label>
      <div class="col-two-thirds">
        <label class="label-gray--small" for="tmpl-antenna1-integration">Integration</label>
        <select id="tmpl-antenna1-integration"></select>
      <!-- </div>

      <div class="col-half"> -->
        <div id="hide-diameter-station1">
          <label class="label-gray--small" for="tmpl-antenna1-diameter">Diameter</label>
          <select id="tmpl-antenna1-diameter"></select>
        </div>
      </div>
      <div class="col-one-third antenna-space">
        <div class="reserve-space" id="tmpl-antenna-support"></div>
      </div>
    </div>

    <div class="col-half column-border">
      <label class="label-top station2name"></label>
      <div class="col-two-thirds">
        <label class="label-gray--small" for="tmpl-antenna2a-integration">Integration</label>
        <select id="tmpl-antenna2a-integration"></select>
      <!-- </div>

      <div class="col-half"> -->
        <div id="hide-diameter-station-2">
          <label class="label-gray--small" for="tmpl-antenna2a-diameter">Diameter</label>
          <select id="tmpl-antenna2a-diameter"></select>
        </div>
      </div>

      <div class="col-one-third antenna-space">
        <div class="reserve-space" id="tmpl-antenna-support2"></div>
      </div>
    </div>
  </div><!-- main section row -->

  <div class="row">

    <div class="col-xs-6">
      <div class="reserve-space" id="tmpl-antenna-support2"></div>
    </div>
  </div>
</div>
<!-- END OF ANTENNA TAB -->

<!-- CONNECTIVITY TAB -->
<div class="tmpl-pane">
  <label class="label-middle">Cables for:</label>
  <div class="my-row">

    <div class="col-half column-border">
      <label class="label-top station1name"></label>
      <div class="" id="tmpl-outdoor-unit-cables-checkbox"></div>

      <div id="tmpl-cable-length-div1">
        <label for="tmpl-outdoor-unit-cables-length" class="inline" style="margin-right: 5px;">Cable length</label>
        <div class="inline limit-input-length-70px" id="tmpl-outdoor-unit-cables-length"></div><span style="margin-left: 5px">meters</span>
      </div>
    </div>

    <div class="col-half column-border">
      <label class="label-top station2name"></label>
      <div class="" id="tmpl-outdoor-unit-cables-checkbox2"></div>

      <div id="tmpl-cable-length-div2">
        <label for="tmpl-outdoor-unit-cables-length2" class="inline" style="margin-right: 5px;">Cable length</label>
        <div class="inline limit-input-length-70px" id="tmpl-outdoor-unit-cables-length2"></div><span style="margin-left: 5px">meters</span>
      </div>

    </div>
  </div>
</div>
<!-- END OF CONNECTIVITY TAB -->
`;
}
