import { 
  model, 
  solution, 
  addToSolution, 
  addToSolutionById,
  isHTML_idInSolution, 
  getObjIdxById,
  getSolutionObjIdxById,
  deleteFromSolutionByHTML_id, 
  deleteFromSolutionByName, 
  deleteFromSolutionById, 
  isObjInSolution,
  triggeredByUser,
  setTriggeredByUser,
  executeCommands,
} from './model';
import { render } from './index';


export var UI = {};

/* =========== Create <option> =========== */
UI.prepareDropdown = (objIdx) => {
  let DOM_target = document.querySelector('#' + model.objects[objIdx].HTML_id);
  if (typeof model.objects[objIdx].size != 'undefined' && !DOM_target.hasAttribute('size')) {
    DOM_target.setAttribute('size', model.objects[objIdx].size);
  }

  if (DOM_target.length === 0 && (typeof model.objects[objIdx].default === 'undefined')) { 
    UI.addEmptyOptionNode(DOM_target);
  }
  
  UI.addOptionNode(objIdx, DOM_target);
  DOM_target.onchange = function (ev) {
    handleDropdownChange(ev);
  }
  
  //If there is any object of this specific HTML_id present in the Solution, it means the default has been already selected, skip.
  if (model.objects[objIdx].default && !isHTML_idInSolution(objIdx)) {
    addToSolutionById(model.objects[objIdx].id);
  }
}

UI.addEmptyOptionNode = (DOM_target) => {
  let el = document.createElement('option');
  el.value = '---';
  el.innerHTML = el.value;
  DOM_target.appendChild(el);
}

/* Create <option> */
UI.addOptionNode = (objIdx, DOM_target) => {
  let option = document.createElement('option');
  option.value = model.objects[objIdx].name;
  option.setAttribute('id', model.objects[objIdx].id);
  option.setAttribute('data-id', model.objects[objIdx].id);
  option.innerHTML = option.value;
  DOM_target.appendChild(option);
}

const handleDropdownChange = (ev) => {
  let objId = ev.target.options[ev.target.selectedIndex].dataset.id;

  if (ev.target.value === '---') {
    deleteFromSolutionByHTML_id(ev.target.id);
    console.log('Solution: ', solution);
  } else {
    addToSolutionById(objId);
  }

  setTriggeredByUser(objId);
  console.log('Dropdown handler, add triggeredByUser: ', objId);

  render(); // triggeredByUser = true, To prevent setting model defaults for a selection
}


/* =========== Create <radio> =========== */
UI.prepareRadio = (objIdx) => {
  let DOM_target = document.querySelector('#' + model.objects[objIdx].HTML_id);
  
  UI.addRadioNode(objIdx, DOM_target);
  DOM_target.onchange = function (ev) {
    handleRadioChange(ev);
  }

  if (model.objects[objIdx].default && !isHTML_idInSolution(objIdx)) addToSolutionById(model.objects[objIdx].id);
}

UI.addRadioNode = (objIdx, DOM_target) => {
  // Radio:
  let radio = document.createElement('input');
  radio.setAttribute('type', 'radio');
  radio.setAttribute('name', model.objects[objIdx].category);
  radio.setAttribute('class','input-radio');
  radio.value = model.objects[objIdx].name;
  radio.setAttribute('id', model.objects[objIdx].id);
  radio.setAttribute('data-id', model.objects[objIdx].id);

  // Label:
  let label = document.createElement('label');
  label.setAttribute('for', radio.name);

  if (typeof model.objects[objIdx].alignment !='undefined'
      && model.objects[objIdx].alignment === 'vertical') 
  {
    label.setAttribute('class', 'label-radio label-radio--vertical');
  } else {
    label.setAttribute('class', 'label-radio');
  }

  let labelTxt = document.createTextNode(radio.value);

  label.appendChild(radio);
  label.appendChild(labelTxt);
  DOM_target.appendChild(label);
}

const handleRadioChange = (ev) => {
  console.log(ev.target.value);
  let objDataId = ev.target.dataset.id;  
  addToSolutionById(objDataId);  

  //triggeredByUser.push(objId); // Might be needed later

  render(); 
}


/* =========== Create Checkbox =========== */
/** Creates checkbox node, assigns click event lister to it and adds it to the DOM tree.
 * @param {string} clickedElemId - id of last clicked UI element. If string is empty,
 * then it means render was not triggered directly by user click on this checkbox. 
 * If the checkbox has "default": true attribute, the checbox will become checked.
 * This check is also made to prevent re-checking of the checkbox when the user wants to uncheck
 * a checkbox that has the default: true attribute during every render cycle.
 */
UI.prepareCheckbox = (objIdx, clickedElemId) => {
  let DOM_target = document.querySelector('#' + model.objects[objIdx].HTML_id);
  
  UI.addCheckboxNode(objIdx, DOM_target);
  DOM_target.onchange = function (ev) {
    handleCheckboxChange(ev);
  }

  if
  (
    (
      clickedElemId === 'start' && // Ran at engine start, first render cycle
      model.objects[objIdx].default === true
    )
  ){
      addToSolutionById(model.objects[objIdx].id);
  }
}

UI.addCheckboxNode = (objIdx, DOM_target) => {
  // Checkbox:
  let checkbox = document.createElement('input');
  checkbox.setAttribute('type', 'checkbox');
  checkbox.setAttribute('name', model.objects[objIdx].id);
  
  if (model.objects[objIdx].hidden) {
    checkbox.setAttribute('class', 'input-checkbox ui-hidden');
  } else {
    checkbox.setAttribute('class','input-checkbox');
  }

  checkbox.value = model.objects[objIdx].name;
  checkbox.setAttribute('id', model.objects[objIdx].id);
  checkbox.setAttribute('data-id', model.objects[objIdx].id);

  if (model.objects[objIdx].disabled) {
    checkbox.setAttribute('disabled', 'disabled');
  }

  // Label:
  let label = document.createElement('label');
  label.setAttribute('for', checkbox.name);

  if (model.objects[objIdx].hidden) {
    label.setAttribute('class', 'label-checkbox ui-hidden');
  } else {
    label.setAttribute('class', 'label-checkbox');
  }

  let labelTxt = document.createTextNode(checkbox.value);

  label.appendChild(checkbox);
  label.appendChild(labelTxt);
  DOM_target.appendChild(label);
}

const handleCheckboxChange = (ev) => { 
  let objId = ev.target.dataset.id;    

  if (ev.target.checked) {
    addToSolutionById(objId);
  } else {
    deleteFromSolutionById(objId);
  }

  setTriggeredByUser(objId);
  console.log('Checkbox handler, add triggeredByUser: ', objId);  

  //console.log('Solution: ', solution);  
  render(objId);
}

/* ============== Prepare Input type "number" ============== */

UI.prepareInputNumber = (objIdx) => {
  let DOM_target = document.querySelector('#' + model.objects[objIdx].HTML_id);
  let inputNumber = UI.addInputNumberNode(objIdx, DOM_target);

  inputNumber.oninput = function (ev) {
    handleInputNumberChange(ev);
  }

  if (!isObjInSolution(model.objects[objIdx].id )){
      addToSolutionById(model.objects[objIdx].id);
  }
}

UI.addInputNumberNode = (objIdx, DOM_target) => {
  let inputNumber = document.createElement('input');
  inputNumber.setAttribute('type', 'number');
  inputNumber.setAttribute('name', model.objects[objIdx].id);
  inputNumber.setAttribute('id', model.objects[objIdx].id);
  inputNumber.setAttribute('data-id', model.objects[objIdx].id);

  if (model.objects[objIdx].hidden) {
    inputNumber.setAttribute('class', 'input-number ui-hidden');
  } else {
    inputNumber.setAttribute('class','input-number');
  }

  // If action was triggered by user, take the new value from the event, 
  // if it was not triggered by user, set the default value set in the model.

  // if (triggeredByUser.includes(model.objects[objIdx].id)) {
  //   let solObjIdx = getSolutionObjIdxById(model.objects[objIdx].id);
  //   inputNumber.setAttribute('value', solution[solObjIdx].value);
  // } else {
  //   // inputNumber.value = model.objects[objIdx].value;
  //   inputNumber.setAttribute('value', model.objects[objIdx].default_value);
  // }

  if (model.objects[objIdx].disabled) {
    inputNumber.setAttribute('disabled', 'disabled');
  }

  DOM_target.appendChild(inputNumber);
  return inputNumber;
}

const handleInputNumberChange = (ev) => { 
  let objId = ev.target.dataset.id; 
  let objIdx = getObjIdxById(objId);

  console.log('Input value: ', ev.target.value);
  solution[getSolutionObjIdxById(objId)].value = parseInt(ev.target.value);
  //console.log('Solution: ', solution);

  setTriggeredByUser(objId);
  
  // Prepare a command used for copying input value to related input value
  var commandsList = [];
  
  if (typeof model.objects[objIdx].commands != 'undefined') {
    model.objects[objIdx].commands.forEach(command => {
      if (command.split(' ')[0] === 'copy-my-value-to-id') commandsList.push(command);
    });
  }
  //====================================

  window.setTimeout(() => {
    console.log('Input number handler, add triggeredByUser: ', objId);
    
    if (model.objects[getObjIdxById(objId)].min_value != 'undefined') {
      // let minVal = model.objects[getObjIdxById(objId)].min_value;
      let solObjIdx = getSolutionObjIdxById(objId);
      let minVal = solution[solObjIdx].min_value;

      if (ev.target.value < minVal) {
        solution[getSolutionObjIdxById(objId)].value = minVal;
      }
    }
    
    if (model.objects[getObjIdxById(objId)].max_value != 'undefined') {
      // let maxVal = model.objects[getObjIdxById(objId)].max_value;
      let solObjIdx = getSolutionObjIdxById(objId);
      let maxVal = solution[solObjIdx].max_value;
      
      if (ev.target.value > maxVal) {
        solution[getSolutionObjIdxById(objId)].value = maxVal;
      }
    }

    //Copy input value to other input only after the min/max value has been correctly set:
    //debugger
    if (commandsList.length > 0) executeCommands({
      objIdThatHasCommand: objId,
      commandsArr: commandsList
    });    
    
    render();
  }, 2000);
}

// Hide DOM elements of type "UI_el": "visibility"
UI.hideDOMelement = (objIdx) => {
  if (model.objects[objIdx].UI_el != 'visibility') return

  let DOM_target = document.querySelector('#' + model.objects[objIdx].HTML_id);

  while (DOM_target.classList.length > 0) {
    DOM_target.classList.remove(DOM_target.classList.item(0));
  };

  DOM_target.classList.add(
    'ui-engine-control-visibility',
  );
}

// Show DOM elements of type "UI_el": "visibility"
UI.showDOMelement = (objIdx) => {
  let DOM_target = document.querySelector('#' + model.objects[objIdx].HTML_id);
  addToSolutionById(model.objects[objIdx].id);

  while (DOM_target.classList.length > 0) {
    DOM_target.classList.remove(DOM_target.classList.item(0));
  };

  DOM_target.classList.add(
    'ui-engine-control-visibility',
    'ui-engine-control-visibility--visible'
  );
}

/**
 * Renders correct UI elements depending on the type
 * @param {number} objIdx - Object index within model.objects array
 * @param {string} clickedElemId - Defines if this cycle has been triggered by user click,
 * this information is used for checking checkboxes that have a default value set to true
 */
UI.renderElement = (objIdx, clickedElemId) => {
  switch (model.objects[objIdx].UI_el) {
    case 'dropdown': 
      UI.prepareDropdown(objIdx);
      break;

    case 'radio': 
      UI.prepareRadio(objIdx);
      break;

    case 'checkbox': 
      UI.prepareCheckbox(objIdx, clickedElemId);
      break;

    case 'number':
      UI.prepareInputNumber(objIdx);
      break;

    case 'visibility':
      UI.showDOMelement(objIdx);

    // case 'showHide':
    //   alert('Now the div should appear');
    //   break;
  }
}

UI.clear = (objIdx) => {
  // Object controls just the visibility, no need to remove whole div from the DOM tree!
  if (model.objects[objIdx].UI_el === 'visibility') return

  let DOM_target = document.querySelector('#' + model.objects[objIdx].HTML_id);
  
  if (DOM_target === null) {
    console.error(`HTML element with id "${model.objects[objIdx].HTML_id}" missing`);
    return
  }

  //try {
    while (DOM_target.firstChild) {
        DOM_target.firstChild.remove();
    }
 // } catch(err) {
    //console.error(`HTML element with id "${model.objects[objIdx].HTML_id}" missing`);
  //}
}

UI.syncSolutionAndUI = () => {
  for (let solIdx = 0; solIdx < solution.length; solIdx++) {

    switch (solution[solIdx].UI_el) {
      case 'dropdown':
        let DOM_target = document.querySelector('#' + solution[solIdx].HTML_id);
        DOM_target.value = solution[solIdx].name;
        break;

      case 'radio': 
        //debugger
        document.querySelector('#' + solution[solIdx].id).checked = true;
        break;

      case 'checkbox': 
        document.querySelector('#' + solution[solIdx].id).checked = true;
        break;

      case 'number': 
        document.querySelector('#' + solution[solIdx].id).value = solution[solIdx].value;
        document.querySelector('#' + solution[solIdx].id).min_value = solution[solIdx].min_value;
        document.querySelector('#' + solution[solIdx].id).max_value = solution[solIdx].max_value;
        break;
    }
  }
}
