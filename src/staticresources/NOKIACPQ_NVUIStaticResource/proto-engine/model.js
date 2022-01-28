var jsonModel = {};
var htmlTemplate = {};

export var model = {}
export var solution = [];
export var commandsQueue = [];
export var triggeredByUser = null;

export var mainLoopRepeat = {
  value: false,
  set: function (bool) { this.value = bool },
}

export var stations = {
  station1name: '',
  station2name: '',
  setStationName: function (station, value) {
    this[station] = value;
  }
}


// export const getCurrentModel = () => model

export const getModel = () => {
  return model
}

export function clearCommandsQueue () {
  commandsQueue = [];
}


function loadHtmlTemplate (vueModelRegion, vueStationOrLink, modelFilePath, templateFilePath) {
  return new Promise((resolve, reject) => {

    //Load UI template: =======================================
    if (typeof htmlTemplate[vueModelRegion] === 'undefined') {
      htmlTemplate[vueModelRegion] = {}
    }

    /* Template has not yet been loaded, load it from local file using AJAX */
    if (typeof htmlTemplate[vueModelRegion][vueStationOrLink] === 'undefined') {
      htmlTemplate[vueModelRegion][vueStationOrLink] = {}
      htmlTemplate[vueModelRegion][vueStationOrLink] = templateFilePath;
      document.querySelector('#ui-engine-' + vueStationOrLink).innerHTML = templateFilePath;
      resolve('template loaded');
    } else {  /* htmlTemplate is already defined, reuse it */
      console.log(`HTML template reused: ${vueModelRegion}\\${vueStationOrLink}`)

      // When coming from other Vue route (eg. JSON template editor), draw the HTML template again.
      if (document.querySelector('#ui-engine-' + vueStationOrLink).innerHTML === '') {
        document.querySelector('#ui-engine-' + vueStationOrLink).innerHTML = htmlTemplate[vueModelRegion][vueStationOrLink];
      }

      resolve('Template reused');
    }
  })
}

export function loadUImodel (vueModelRegion, vueStationOrLink, modelFilePath, templateFilePath) {
  return new Promise((resolve, reject) => {
    if (typeof jsonModel[vueModelRegion] === 'undefined') {
      jsonModel[vueModelRegion] = {}
    }

    /* UI Model has not yet been loaded, load it from local file using AJAX */
    if (
      typeof jsonModel[vueModelRegion][vueStationOrLink] === 'undefined' ||
      jsonModel[vueModelRegion][vueStationOrLink] === []
      ) {
      jsonModel[vueModelRegion][vueStationOrLink] = []
      // jsonModel[vueModelRegion][vueStationOrLink] = JSON.parse(modelFilePath);
      model = jsonModel[vueModelRegion][vueStationOrLink];
      resolve('Model loaded');
    } else {  /* jsonModel is already defined, reuse it */
      model = jsonModel[vueModelRegion][vueStationOrLink];
      console.log('Model reused', model);
      resolve('Model reused');
    }
  })
}

//Can be used for debugging async functions
const sleepPromise = (delay) => {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      console.info('Sleeping...');
      resolve();
    },
    delay)
  });
}

export async function switchModelInUIEngine (vueModelRegion, vueStationOrLink, modelFilePath, templateFilePath) {
    return Promise.all([
      await loadHtmlTemplate(vueModelRegion, vueStationOrLink, modelFilePath, templateFilePath),
      await loadUImodel(vueModelRegion, vueStationOrLink, modelFilePath, templateFilePath)
    ])
}


function ajaxGet (modelFilePath) {
  return new Promise (function (resolve, reject) {
    var xhr = new XMLHttpRequest();

    xhr.onreadystatechange = async () => {
      if ((xhr.readyState === 4 && xhr.status === 200) ||
         (xhr.readyState === 4 && xhr.status === 304)) {
        let res = xhr.responseText;

        // await sleepPromise(6000);
        resolve(res);
      }
    }


    xhr.open("GET", modelFilePath, true);
    xhr.send();
  })
}

export const restoreSolution = (data) => {
  solution = data;
}

export const getSolutionFromUIEngine = () => {
  return JSON.parse(JSON.stringify(solution));
}

export const setTriggeredByUser = (newVal) => {
  triggeredByUser = newVal;
}

export const emptySolution = () => {
  solution = [];
}

export const constraintsPassed = (objIdx) => {
  // if no constraints defined for object, pass the test automatically:
  if (!model.objects[objIdx].constraints || model.objects[objIdx].constraints.length === 0) return true;
  let constraintsArr = model.objects[objIdx].constraints;

  // Group constraints in the "AND" statement groups
  this.groupConstraintsByAnd = (constraintsArr) => {
    let constraintsGroupedByAnd = [ [] ];

    constraintsArr.forEach(elem => {
      if (elem != 'or' && elem != 'and') {
        constraintsGroupedByAnd[constraintsGroupedByAnd.length-1].push(elem);
      }

      if (elem === 'or') {
        constraintsGroupedByAnd.push([]);
      }
    });
    return constraintsGroupedByAnd
  }


  //Evaluate "AND" statments group
  this.evaluateAndGroups = (AndGroup) => {
    let evaluatedAndGroups = [];

    AndGroup.forEach(constraints => {
      let groupPassed = true;

      // For loop, to break early if conditions met
      for (let consIdx = 0; consIdx < constraints.length; consIdx++) {
        // if (!this.hasConstraintPassed(...groupedContraints[consIdx])) {
        if (!this.hasConstraintPassed(constraints[consIdx])) {
          groupPassed = false;
          break
        }
      }

      evaluatedAndGroups.push(groupPassed);
    });

    return evaluatedAndGroups
  }

  // Evaluate "OR" statements group
  this.evaluateOrGroups = (evaluatedAndGroups) => {
    let finalResult = false;
    // For loop, to break early if conditions met
    for (let consIdx = 0; consIdx < evaluatedAndGroups.length; consIdx++) {
      if (evaluatedAndGroups[consIdx]) {
        finalResult = true;
        break
      }
    }

    return finalResult
  }

  this.hasConstraintPassed = (constraint) => {
    let partials = constraint.split(' ');

    switch (partials[0]) {
      case 'contains-item-of-category':
      if (isCategoryInSolution(partials[1])) {
        return true
      } else {
        return false;
      }

      case 'contains-item-of-subcategory':
      if (isSubcategoryInSolution(partials[1])) {
          return true
      } else {
        return false
      }

      case 'contains-item':
      if (isItemInSolution(partials[1])) {
          return true
      } else {
        return false
      }

      case 'contains-items':
      /* one object: */
      if (partials.length === 2) {
        if (isItemInSolution(partials[1])) {
            return true
        } else {
          return false
        }
      /* more than one object */
      } else {
        if (areItemsInSolution( partials.slice(1, partials.length) ) ) {
            return true
        } else {
          return false
        }
      }

      case 'contains-tag':
      if (isTagInSolution(partials[1])) {
          return true
      } else {
        return false
      }

      case 'doesnt-contain-tag':
      if (!isTagInSolution(partials[1])) {
          return true
      } else {
        return false
      }


      case 'doesnt-contain-item':
      if (isItemNotInSolution(partials[1])) {
          return true
      } else {
        return false
      }

      case 'doesnt-contain-items':
      if (partials.length === 2) {
        if (isItemNotInSolution(partials[1])) {
            return true
        } else {
          return false
        }
      } else {
        if (areItemsNotInSolution( partials.slice(1, partials.length) ) ) {
            return true
        } else {
          return false
        }
      }
    } // switch
  }

  // debugger
  let constraintsGroupedByAnd = this.groupConstraintsByAnd(constraintsArr);
  // console.log(`constraintsGroupedByAnd:`, constraintsGroupedByAnd)
  let evaluatedAndGroups = this.evaluateAndGroups(constraintsGroupedByAnd);
  // console.log(`evaluatedAndGroup: `, evaluatedAndGroups)
  let finalPassed = this.evaluateOrGroups(evaluatedAndGroups);
  // console.log(`finalPassed:`, finalPassed)

  return finalPassed;
}


const getObjIdxByName = (objName) => {
  for (let objIdx = 0; objIdx < model.objects.length; objIdx++) {
    if (model.objects[objIdx].name === objName) return objIdx
  }

  return -1
}

export const getObjIdxById = (objId) => {
  // objId is "id" in model json attribute, objIdx is index of array "models.objects[objIdx]"
  for (let objIdx = 0; objIdx < model.objects.length; objIdx++) {
    if (model.objects[objIdx].id === objId) {
      return objIdx
    }
  }

  return -1
}

export const getSolutionObjIdxById = (objId) => {
  // objId is "id" in model json attribute, objIdx is index of array "models.objects[objIdx]"
  for (let objIdx = 0; objIdx < solution.length; objIdx++) {

    if (solution[objIdx].id === objId) {
      return objIdx
    }
  }

  return -1
}


export const isObjInSolution = (objId) => {
  for (let objIdx = 0; objIdx < solution.length; objIdx++) {
    if (solution[objIdx].id === objId) return true
  }

  return false
}

export const isHTML_idInSolution = (objIdx) => {
  for (let solIdx = 0; solIdx < solution.length; solIdx++) {
    if (solution[solIdx].HTML_id === model.objects[objIdx].HTML_id) return true
  }

  return false
}

export const deleteFromSolutionByName = (objName) => {
  for (let objIdx = 0; objIdx < solution.length; objIdx++) {
    if (solution[objIdx].name === objName) {
      solution.splice(objIdx, 1);
    }
  }
}

export const deleteFromSolutionById = (objId) => {
  for (let objIdx = 0; objIdx < solution.length; objIdx++) {
    if (solution[objIdx].id === objId) {
      solution.splice(objIdx, 1);
      mainLoopRepeat.set(true);
      break;
    }
  }
}

export const deleteFromSolutionByHTML_id = (HTML_id) => {
  for (let solIdx = 0; solIdx < solution.length; solIdx++) {
    if (solution[solIdx].HTML_id === HTML_id) {
      solution.splice(solIdx, 1);
    }
  }
}

const deleteFromSolutionObjOfSameCategory = (objId) => {
  let objIdx = getObjIdxById(objId);
  let objCategory = model.objects[objIdx].category;
  if (typeof objCategory === 'undefined') return // to prevent deletion of every object that has no "category" attribute specified

  for (let objIdx = 0; objIdx < solution.length; objIdx++) {
    if (solution[objIdx].category === objCategory) {
      deleteFromSolutionById(solution[objIdx].id);
    }
  }
}

export const deleteFromSolutionByIndex = (objIdx) => {
  for (let solIdx = 0; solIdx < solution.length; solIdx++) {
    if (solution[solIdx].id === model.objects[objIdx].id) {
      solution.splice(solIdx, 1);
    }
  }
}

const isCategoryInSolution = (categoryName) => {
  for (let solIdx = 0; solIdx < solution.length; solIdx++) {
    if (solution[solIdx].category === categoryName) return true;
  }
  return false;
}

const isSubcategoryInSolution = (subcategoryName) => {
  for (let solIdx = 0; solIdx < solution.length; solIdx++) {
    if (solution[solIdx].subcategory === subcategoryName) return true;
  }
  return false;
}

export const isItemInSolution = (itemId) => {
  for (let solIdx = 0; solIdx < solution.length; solIdx++) {
    if (solution[solIdx].id === itemId) return true;
  }
  return false;
}

const isItemNotInSolution = (itemId) => {
  for (let solIdx = 0; solIdx < solution.length; solIdx++) {
    if (solution[solIdx].id === itemId) return false;
  }
  return true;
}

const areItemsInSolution = (items) => {
  for (let arrIdx = 0; arrIdx < items.length; arrIdx++) {
    let found = false;

    for (let solIdx = 0; solIdx < solution.length; solIdx++) {
      if (solution[solIdx].id === items[arrIdx]) found = true;
    }

    if (!found) return false
  }

  return true;
}

// change method name to something more natural sounding?
const areItemsNotInSolution = (items) => {
  for (let arrIdx = 0; arrIdx < items.length; arrIdx++) {
    let found = false;

    for (let solIdx = 0; solIdx < solution.length; solIdx++) {
      if (solution[solIdx].id === items[arrIdx]) found = true;
    }

    if (found) return false
  }

  return true;
}

const getSolObjIdsOfCategory = (category) => {
  return solution.filter(solItem => {
    if (typeof solItem.categories != 'undefined') {
      //return solItem.categories.includes(category)
      return solItem.categories.indexOf(category) != -1
    }
  });
}

/**
 * Iterates through the Solution objects and checks if any obj contains the required tag
 * @param {string} tag the searched tag
 * @returns {bool} if the tag was found
 */
const isTagInSolution = (tag) => {
  let passed = false;

  for (let solIdx = 0; solIdx < solution.length; solIdx++) {
    if (typeof solution[solIdx].tags != 'undefined') {
      solution[solIdx].tags.forEach((solTag, solTagIdx) => {
        if (solTag === tag) passed = true;
      });
    }
  }

  return passed;
}


export const addToSolutionById = (objId) => {
  // let objIdx = getObjIdxById(objId);
  //
  // if (typeof model.objects[objIdx].UI_el != 'undefined' &&
  //    (model.objects[objIdx].UI_el === 'dropdown' ||
  //     model.objects[objIdx].UI_el === 'radio')
  // ) {
  //   deleteFromSolutionByHTML_id(model.objects[objIdx].HTML_id);
  // }
  //
  // if (!isObjInSolution(model.objects[objIdx].id) ) {
  //   solution.push(JSON.parse(JSON.stringify(model.objects[objIdx])));
  //   mainLoopRepeat.set(true);
  //
  //   if(typeof model.objects[objIdx].commands != 'undefined') {
  //     commandsQueue.push({
  //       objId: model.objects[objIdx].id,
  //       commands: model.objects[objIdx].commands
  //     });
  //   }
  // }
  //
  //
  // let solNamesList = solution.reduce((acc, obj) => {
  //   acc.push(obj.id);
  //   return acc
  // }, []);
  return true
  // console.log("Added to Solution (id's list): ", solNamesList);
}


export const executeCommands = ({objIdThatHasCommand, commandsArr}) => {
  commandsArr.forEach(command => {
    let partials = command.split(' ');
    let objIdx = getObjIdxById(partials[1]);
    let objIdxThatHasCommand = getObjIdxById(objIdThatHasCommand);

    switch (partials[0]) {
      case 'select':
        if ( constraintsPassed(objIdx) && !isItemInSolution(partials[1]) ) addToSolutionById(partials[1]);
      break;

      case 'set-default-value':
        if (
          constraintsPassed(objIdx)
          && isItemInSolution(partials[1])
          && triggeredByUser === model.objects[objIdxThatHasCommand].id
          // check if command is issued by obj that user clicked on, if yes, then assign default value to the target
        ) {
          let solObjIdx = getSolutionObjIdxById(partials[1]);
          solution[solObjIdx].value = model.objects[objIdx].default_value;
        }
      break;

      case 'set-min-value':
        if (
          constraintsPassed(objIdx)
          && isItemInSolution(partials[1])
          && isItemInSolution(objIdThatHasCommand)
          // check if command is issued by obj that user clicked on, if yes, then assign default value to the target
          ) {
            let solObjIdx = getSolutionObjIdxById(partials[1]);
            solution[solObjIdx].min_value = parseInt(partials[2]);
            console.log(`Set object:"${solution[solObjIdx].name}" min value to ${partials[2]}`);
          }
      break;

      case 'set-max-value':
        if (
          constraintsPassed(objIdx)
          && isItemInSolution(partials[1])
          && isItemInSolution(objIdThatHasCommand)
          // check if command is issued by obj that user clicked on, if yes, then assign default value to the target
        ) {
          let solObjIdx = getSolutionObjIdxById(partials[1]);
          solution[solObjIdx].max_value = parseInt(partials[2]);
          console.log(`Set object:"${solution[solObjIdx].name}" max value to ${partials[2]}`);
        }
      break;

      case 'set-value':
          let solObjIdx = getSolutionObjIdxById(partials[1]);
          if (solObjIdx === -1) return
        if (
          constraintsPassed(objIdx)
          && isItemInSolution(partials[1])
          && isItemInSolution(objIdThatHasCommand)
          && triggeredByUser != partials[1]
          // check if command is issued by obj that user clicked on, if yes, then assign default value to the target
        ) {
          solution[solObjIdx].value = parseInt(partials[2]);
          console.log(`Set object:"${solution[solObjIdx].name}" value to ${partials[2]}`);
        }
      break;

      case 'copy-my-value-to-id':
        if (
          constraintsPassed(objIdx) &&
          isItemInSolution(partials[1]) &&
          triggeredByUser === model.objects[objIdxThatHasCommand].id
          // check if command is issued by obj that user clicked on, if yes, then assign default value to the target
        ) {
          let triggeredSolObjIdx = getSolutionObjIdxById(model.objects[objIdxThatHasCommand].id);
          let valueToCopy = solution[triggeredSolObjIdx].value;
          let solObjIdx = getSolutionObjIdxById(partials[1]);
          solution[solObjIdx].value = valueToCopy;
          console.log(`Set object:"${solution[solObjIdx].name}" value to ${valueToCopy}`);
        }
      break;

      case 'trigger-commands-of-categories':
        let categoriesArr = [];

        for (let pIdx = 1; pIdx < partials.length; pIdx++) {
          categoriesArr.push(partials[pIdx]);
        }

        if (
          /* check if command is issued by obj that user clicked on, if yes, then assign default value to the target */
         triggeredByUser === model.objects[objIdxThatHasCommand].id
        ) {
          let objsToTriggerArr = [] // Array of objects to trigger that contain categories

          categoriesArr.forEach(category => {
            if (category === 'outdoor-unit-cables')
            objsToTriggerArr.push(...getSolObjIdsOfCategory(category));
          });

          objsToTriggerArr.forEach(objToTrigger => {
            let solObjId = objToTrigger.id;
            let solObjIdx = getSolutionObjIdxById(objToTrigger.id);

            if (typeof solution[solObjIdx].commands != 'undefined') {
              executeCommands({
                objIdThatHasCommand: solObjId,
                commandsArr: solution[solObjIdx].commands
              })
            }
          })
        } // if
      break;
    }
  });
}
