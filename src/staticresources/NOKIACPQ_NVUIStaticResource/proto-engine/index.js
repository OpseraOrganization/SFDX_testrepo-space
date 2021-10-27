import { UI } from './UI';
import { 
  model,
  mainLoopRepeat,
  stations,
  commandsQueue, 
  clearCommandsQueue,
  constraintsPassed,
  executeCommands,
  triggeredByUser,
  setTriggeredByUser,
  isItemInSolution,
  deleteFromSolutionByIndex,
  restoreSolution,
  emptySolution,
  getObjIdxById,
  solution,
  switchModelInUIEngine
} from './model';

// Panes displayed in the link view in right sidebar of Network View configurator
let allPanes, 
    everyTab, 
    showAllTab;

    // window.station1name='',
    // window.station2name='';
    // stations.setStationName(station1, '')

const setActiveTab = (idx) => {
  allPanes.forEach(pane => pane.classList.remove('tmpl-pane--visible'));
  everyTab.forEach(tab => tab.classList.remove('tmpl-tab--active'));

  allPanes[idx].classList.add('tmpl-pane--visible');
  everyTab[idx].classList.add('tmpl-tab--active');
}

// Sets the tab called "All" (when active, all sections are visible) as active
const setActiveAllTabs = () => {
  allPanes.forEach(tab => tab.classList.add('tmpl-pane--visible') );
  everyTab.forEach(tab => tab.classList.add('tmpl-tab--active') );
}

// Runs when app is initialized
const setupTabs  = () => {
    allPanes = document.querySelectorAll('.tmpl-pane');
    if (allPanes.length === 0) return

    everyTab = document.querySelectorAll('.tmpl-tab');
    showAllTab = document.querySelector('.tmpl-tab-show-all');
    
    // hide all panes
    allPanes.forEach(pane => pane.classList.add('tmpl-pane--visible'));
    allPanes[0].classList.remove('tmpl-pane--visible');

    // setup tab click event handlers
    everyTab.forEach((tab, idx) => {
      tab.onclick = () => {
        setActiveTab(idx);
      }
    });

    showAllTab.onclick = (ev) => {
      setActiveAllTabs();
    };

    // set active tab to tab nr 1
    //setActiveTab(0);
    // set "all" tab active
    setActiveAllTabs();
}

export const startEngine = (vueStationOrLink, sublinkIdx, webworkerId) => {
    setupTabs();
    emptySolution();
    // render('start');
    render('start', vueStationOrLink, sublinkIdx, webworkerId);
}


/**
 * Main app loop.
 * Clears the UI, checks the the constraints/rules and displays correct 
 * UI elements (inputs, checkboxes etc.).
 * @param {string} clickedEl - defines if this cycle has 
 * been triggered by user click, this information is used for 
 * checking checkboxes that have a default value set to true
 * @param {string} vueStationOrLink - passed back to the Vue app, 
 * so it knows where the solution should be returned to
 * @param {number} sublinkIdx - passed back to the Vue app, 
 * so it knows where the solution should be returned to
 * @param {string} webworkerId - passed back to the Vue app, 
 * so it knows where the solution should be returned to
 **/
export var render = (clickedEl = '', vueStationOrLink, sublinkIdx, webworkerId) => { // To prevent setting model defaults for a selection) => {
  mainLoopRepeat.set(true);
  let repeatCounter = 0;
  /*
  Run iteration one more time if anything is added to the solution using addToSolutionById
  */
  // for (let iter = 0; iter < 5; iter++) { // 
  while (mainLoopRepeat.value) {
    // Repeat the main loop only if something is added to the solution.
    mainLoopRepeat.set(false);
    repeatCounter++;


    /* 1) Clear the UI */
    model.objects.forEach((obj, objIdx) => {
        UI.clear(objIdx);
    });  
  
    /* 2) Render UI DOM elements */
    model.objects.forEach((obj, objIdx) => {
      if (constraintsPassed(objIdx)) {
        UI.renderElement(objIdx, clickedEl);
      } else {
        deleteFromSolutionByIndex(objIdx);
        UI.hideDOMelement(objIdx);
      }
    });
  
    /* 3) Synchronize UI with the Solution */
    UI.syncSolutionAndUI();


    /* 4) Trigger commands */
    commandsQueue.forEach((commandsQueueItem) => {
      executeCommands({
        objIdThatHasCommand: commandsQueueItem.objId,
        commandsArr: commandsQueueItem.commands
      });
    });
    
  } // end of for loop, iterations

  const allCheckboxes = document.getElementsByTagName("select")
  Array.prototype.forEach.call((allCheckboxes), element => {
    setOptionsLengthDropdown(element)
  })
  
  clearCommandsQueue();

  /* 5) Render station names in the Links view */
  if (typeof stations.station1name != 'undefined') {
    document.querySelectorAll('.station1name').forEach(item => item.innerHTML = '"' + stations.station1name + '"');
  }
  if (typeof stations.station2name != 'undefined') {
    document.querySelectorAll('.station2name').forEach(item => item.innerHTML = '"' + stations.station2name + '"');
  }

  /* 6) Re-set focus to the last clicked element (this is necessary, as on each
    UI render cycle, the UI is cleared and redrawn from scratch)
  */
  if (triggeredByUser !=  null) {
    console.log(`UI_el triggered by user: ${triggeredByUser}`);
    let objIdx = getObjIdxById(triggeredByUser);

    if (model.objects[objIdx].UI_el === 'number') {
      console.log('Re-set UI focus to: ', model.objects[objIdx].id);
      document.querySelector('#' + model.objects[objIdx].id).focus();
    }
    setTriggeredByUser(null);
  }

  // 7) Send solution back to application
  // optional todo: put communication in adapter, a "bridge", instead of hard coding it.
  // Why? I you were to use this UI engine with React instead of Vue - you would have
  // to rewrite this part completely for it to work.
  $nuxt.$bus.$emit('solutionUpdated',
  { 
    type: vueStationOrLink,
    sublinkIdx: sublinkIdx, 
    webworkerId: webworkerId,
    solutionFromUIEngine: solution 
  }); // Send solution back to Vue, so the UI is up-to-date.

  // Used for debugging, comment out if not needed:
}


const setOptionsLengthDropdown = (element) => {
    element.setAttribute('size', element.childElementCount)
}

export async function sendSolutionToUIEngine (
  vueModelRegion, // eg. "ETSI" or "ANSI"
  vueStationOrLink, 
  sublinkIdx,
  webworkerId,
  vueSolutionData, // Vue UI selections
  modelFilePath, 
  templateFilePath,
  station1name,
  station2name) {

  if (station1name && station2name) {
    stations.setStationName('station1name', station1name);
    stations.setStationName('station2name', station2name);
  }

  // switches/loads ANSI/ETSI and station/link models. 
  await switchModelInUIEngine(
    vueModelRegion,
    vueStationOrLink,
    modelFilePath,
    templateFilePath
  );
  
  // new station or link sent, initialize engine
  if (vueSolutionData === null) {
    startEngine(vueStationOrLink, sublinkIdx, webworkerId) 
  } else {
    setupTabs();   
    restoreSolution(vueSolutionData);
    render(null, vueStationOrLink, sublinkIdx, webworkerId);
  }

}

