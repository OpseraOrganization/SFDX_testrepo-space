export const ansiLink = () => {
return `<!-- Copyright Nokia 2020 -->
<div>Async ANSI link template</div>
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

  <!-- </div> -->
  <div class="spacer-15"></div>
  <div class="spacer-15"></div>

  <!-- CAPACITY/RADIO FEATURES ROW -->
  <!-- <div class="row"> -->
  <div class="col-three-fifths column-border" style="height: 258px;">
    <label class="label-top" for="">Capacity license (per UBT)</label>

    <div class="col-half">
      <div class="reserve-space"></div>
      <select id="tmpl-ubt1-capacity"></select>
    </div>

    <div class="col-half">
      <!--<label class="label-top" style="font-size: 13px!important;" for="show-2nd-ubt-capacity"></label>-->
      <div class="reserve-space font-size-13px" id="tmpl-show-2nd-ubt-capacity" style="font-size: 13px;"></div>

      <select id="tmpl-ubt2-capacity"></select>
    </div>
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

  <!-- </div> -->
  <div class="spacer-15"></div>
    <!-- END OF CAPACITY/RADIO FEATURES ROW -->
</div>



<div class="container tmpl-pane">
  <!-- =========================== UBT 1: ============================== -->
  <h4>UBT 1</h4>
  <div class="row pane-border">
    <!-- ROW CONTAINING BOTH MAIN COLS -->
    <div class="col-xs-4">
      <label for="tmpl-tx1-frequency">Frequency</label>
      <select id="tmpl-tx1-frequency"></select>
    </div>

    <div class="col-md-4">
      <label for="tmpl-bandwidth-ubt1">Bandwidth</label>
      <select id="tmpl-bandwidth-ubt1"></select>
    </div>

    <div class="col-md-4">
      <label for="tmpl-modulation-ubt1">Modulation</label>
      <select id="tmpl-modulation-ubt1"></select>
    </div>
  </div>

  <div class="spacer-15"></div>

  <div class="row pane-border">
    <div class="col-md-12">
      <div class="col-md-6" style="text-align:center;" :title="station1name">
        <strong>Station<span class="station1name"></span></strong>

        <div class="row row-gap">
          <div class="tx-rx-label">
            <span class="label">TX1</span>
          </div>

          <div class="tx-rx-input">
            <div id="tmpl-frequency-station1-tx1"></div>
          </div>

          <div class="tx-rx-label">
            <span class="label">MHz
          </span></div>
        </div>

        <div class="row row-gap">
          <div class="tx-rx-label">
            <span class="label">RX1
          </span></div>

          <div class="tx-rx-input">
            <div id="tmpl-frequency-station1-rx1"></div>
          </div>

          <div class="tx-rx-label">
            <span class="label">MHz
          </span></div>
        </div>
        <div id="tx-rx-control">
          <div class="row row-gap">
            <div class="tx-rx-label">
              <span class="label">TX2
            </span></div>

            <div class="tx-rx-input">
              <div id="tmpl-frequency-station1-tx2"></div>
            </div>

            <div class="tx-rx-label">
              <span class="label">MHz
            </span></div>
          </div>

          <div class="row row-gap">

            <div class="tx-rx-label">
              <span class="label">RX2
            </span></div>

            <div class="tx-rx-input">
              <div id="tmpl-frequency-station1-rx2"></div>
            </div>

            <div class="tx-rx-label">
              <span class="label">MHz
            </span></div>
          </div>
        </div>


      </div>
      <div class="col-md-6">
        <div style="text-align:center;" :title="station2name"><strong>Station
          <span class="station2name"></span></strong>


          <div class="row row-gap">
            <div class="tx-rx-label">
              <span class="label">TX1</span>
            </div>

            <div class="tx-rx-input">
              <div id="tmpl-frequency-station2-tx1"></div>
            </div>

            <div class="tx-rx-label">
              <span class="label">MHz
            </span></div>
          </div>

          <div class="row row-gap">
            <div class="tx-rx-label">
              <span class="label">RX1</span>
            </div>
            <div class="tx-rx-input">
              <div id="tmpl-frequency-station2-rx1"></div>
            </div>
            <div class="tx-rx-label">
              <span class="label">MHz
            </span></div>
          </div>

          <div id="tx-rx-control2">
            <div class="row row-gap">
              <div class="tx-rx-label">
                <span class="label">TX2</span>
              </div>
              <div class="tx-rx-input">
                <div id="tmpl-frequency-station2-tx2"></div>
              </div>

              <div class="tx-rx-label">
                <span class="label">MHz
              </span></div>
            </div>

            <div class="row row-gap">
              <div class="tx-rx-label">
                <span class="label">RX2</span>
              </div>
              <div class="tx-rx-input">
                <div id="tmpl-frequency-station2-rx2"></div>
              </div>

              <div class="tx-rx-label">
                <span class="label">MHz
              </span></div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div class="col-md-4">
    <!-- empty -->
  </div>
  <!--row -->

  <div class="row">
    <div class="col-md-12">
      <label for="tmpl-show-2nd-transceiver-settings"></label>
      <div style="margin: 15px 0;" id="tmpl-show-2nd-transceiver-settings"></div>
    </div>
  </div>


  <!-- </div> -->
  <!-- container tmpl-pane end -->

  <!-- =========================== UBT 2: ============================== -->
  <label for="tmpl-show-2nd-ubt-frequency-settings"></label>
  <div id="tmpl-show-2nd-ubt-frequency-settings"></div>
  <div id="ubt2-div-js">
  <h4>UBT 2</h4>
    <div class="row pane-border">
      <!-- ROW CONTAINING BOTH MAIN COLS -->
      <div class="col-xs-4">
        <label for="tmpl-tx3-frequency">Frequency</label>
        <select id="tmpl-tx3-frequency"></select>
      </div>

      <div class="col-md-4">
        <label for="tmpl-bandwidth-ubt2">Bandwidth</label>
        <select id="tmpl-bandwidth-ubt2"></select>
      </div>

      <div class="col-md-4">
        <label for="tmpl-modulation-ubt2">Modulation</label>
        <select id="tmpl-modulation-ubt2"></select>
      </div>
    </div>

    <div class="spacer-15"></div>

    <div class="row pane-border">
      <div class="col-md-12">
        <div class="col-md-6" style="text-align:center;" :title="station1name">
          <strong>Station<span class="station1name"></span></strong>

          <div class="row row-gap">
            <div class="tx-rx-label">
              <span class="label">TX1</span>
            </div>

            <div class="tx-rx-input">
              <div id="tmpl-frequency-station1-tx3"></div>
            </div>

            <div class="tx-rx-label">
              <span class="label">MHz
            </span></div>
          </div>

          <div class="row row-gap">
            <div class="tx-rx-label">
              <span class="label">RX1
            </span></div>

            <div class="tx-rx-input">
              <div id="tmpl-frequency-station1-rx3"></div>
            </div>

            <div class="tx-rx-label">
              <span class="label">MHz
            </span></div>
          </div>

          <div id="tx-rx-control3">
            <div class="row row-gap">
              <div class="tx-rx-label">
                <span class="label">TX2
              </span></div>

              <div class="tx-rx-input">
                <div id="tmpl-frequency-station1-tx4"></div>
              </div>

              <div class="tx-rx-label">
                <span class="label">MHz
              </span></div>
            </div>

            <div class="row row-gap">

              <div class="tx-rx-label">
                <span class="label">RX2
              </span></div>

              <div class="tx-rx-input">
                <div id="tmpl-frequency-station1-rx4"></div>
              </div>

              <div class="tx-rx-label">
                <span class="label">MHz
              </span></div>
            </div>
          </div>


        </div>
        <div class="col-md-6">
          <div style="text-align:center;" :title="station2name"><strong>Station
            <span class="station2name"></span></strong>


            <div class="row row-gap">
              <div class="tx-rx-label">
                <span class="label">TX1</span>
              </div>

              <div class="tx-rx-input">
                <div id="tmpl-frequency-station2-tx3"></div>
              </div>

              <div class="tx-rx-label">
                <span class="label">MHz
              </span></div>
            </div>

            <div class="row row-gap">
              <div class="tx-rx-label">
                <span class="label">RX1</span>
              </div>
              <div class="tx-rx-input">
                <div id="tmpl-frequency-station2-rx3"></div>
              </div>
              <div class="tx-rx-label">
                <span class="label">MHz
              </span></div>
            </div>

            <div id="tx-rx-control4">
              <div class="row row-gap">
                <div class="tx-rx-label">
                  <span class="label">TX2</span>
                </div>
                <div class="tx-rx-input">
                  <div id="tmpl-frequency-station2-tx4"></div>
                </div>

                <div class="tx-rx-label">
                  <span class="label">MHz
                </span></div>
              </div>

              <div class="row row-gap">
                <div class="tx-rx-label">
                  <span class="label">RX2</span>
                </div>
                <div class="tx-rx-input">
                  <div id="tmpl-frequency-station2-rx4"></div>
                </div>

                <div class="tx-rx-label">
                  <span class="label">MHz
                </span></div>
              </div>
            </div>

          </div>
        </div>
      </div>
    </div>
  </div>

  <div class="col-md-4">
    <!-- empty -->
  </div>
  <!--row -->

  <div class="row">
    <div class="col-md-12">
      <label for="tmpl-show-2nd-transceiver-settings"></label>
      <div style="margin: 15px 0;" id="tmpl-show-2nd-transceiver-settings"></div>
    </div>
  </div>

</div><!-- container tmpl-pane end -->


<!-- ANTENNA TAB -->
<div class="tmpl-pane">
  <label class="label-middle">Antenna for:</label>
  <!-- <h4>Antenna </h4> -->
  <div class="my-row">
    <div class="col-half column-border">
      <label class="label-top station1name"></label>
      <div class="col-two-thirds">
        <label class="label-gray--small" for="tmpl-antenna1-integration">Integration</label>
        <select id="tmpl-antenna1-integration"></select>
      <!-- </div>

      <div class="col-half"> -->
        <div id="hide-diameter-antena-1">
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
        <div id="hide-diameter-antena-2">
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
      <label class="label-top station1name" for="tmpl-outdoor-unit-cables-checkbox"></label>
      <div class="" id="tmpl-outdoor-unit-cables-checkbox"></div>

      <div id="tmpl-cable-length-div1">
        <label for="tmpl-outdoor-unit-cables-length" class="inline" style="margin-right: 5px;">Cable length</label>
        <div class="inline limit-input-length-70px" id="tmpl-outdoor-unit-cables-length"></div><span style="margin-left: 5px">meters</span>
      </div>
    </div>

    <div class="col-half column-border">
      <label class="label-top station2name" for="tmpl-outdoor-unit-cables-checkbox2"></label>
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
