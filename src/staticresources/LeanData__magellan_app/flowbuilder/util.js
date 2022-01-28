function initializeMagellanUtil() {
	if (typeof Magellan === "undefined")
    Magellan = {};

  if (typeof Magellan.Util === "undefined")   
    Magellan.Util = {};


  Magellan.Util.objectTypes = ['Lead', 'Contact', 'Account', 'Opportunity'];
    
  Magellan.Util.isValidEmail = function(email) {
    var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(String(email).toLowerCase());
  }	
		
  Magellan.Util.fetchNodeAuxMaps = function() {
      getScriptCachable(resourceURL + "/json/TriggerAuxMap.js");
      getScriptCachable(resourceURL + "/json/DecisionAuxMap.js");
      getScriptCachable(resourceURL + "/json/MatchAuxMap.js");
      getScriptCachable(resourceURL + "/json/ActionAuxMap.js");
      getScriptCachable(resourceURL + "/json/ReRouteAuxMap.js");
      getScriptCachable(resourceURL + "/json/PartnerAuxMap.js");
  }

  Magellan.Util.getAllNodes = function(graphOrGraphJSON) {
    if (_.isObject(graphOrGraphJSON) && _.isArray(graphOrGraphJSON['businessLogic'])) {
      return Magellan.Util.constructGraphFromJSON(graphOrGraphJSON);
    }
    
    var diaGraph = graphOrGraphJSON || window.graph;
    if (!(diaGraph instanceof joint.dia.Graph)) {
      throw new Error("Require graph to get all nodes!");
    }

    var allElements = diaGraph.getElements();
    var allNodes = _.filter(allElements, function(element) {
      return element instanceof Magellan.Models.Node;
    });
    return allNodes;
  };

  Magellan.Util.getNodeNamesToNodesMap = function() {
  	var nodeNamesToNodesMap = {};
    var allNodes = Magellan.Util.getAllNodes(window.graph);
  	_.each(allNodes,function(node){
  		nodeNamesToNodesMap[node.nodeInfo.name] = node;
  	});
  	return nodeNamesToNodesMap;
  };

  Magellan.Util.getNodeNamesToNodesMapFromJSON = function(graphJSON) {
    var nodeNamesToNodesMap = {};
    var allNodes = Magellan.Util.constructGraphFromJSON(graphJSON);
    _.each(allNodes,function(node){
      nodeNamesToNodesMap[node.nodeInfo.name] = node;
    });
    return nodeNamesToNodesMap;
  };

  //TODO:  seperate this model construction logic from adding to graph
	//ala Magellan.Controllers.GUI.assembleGraphFromJSON
  Magellan.Util.constructGraphFromJSON = function(graphJSON) {
		var allNodes = [];
		_.each(graphJSON.businessLogic, function (nodeLogic) {
	    var nodeInfo = nodeLogic[0];
	    var nodePosition = nodeLogic[1];
	    var nodeConstructor = Magellan.Models.getObjectByName(nodeInfo.magellanClass);
	    var newNode = new nodeConstructor({position: nodePosition, nodeInfo: nodeInfo, fromJSON: true});
      allNodes.push(newNode);
	  });
    return allNodes;
	};

	Magellan.Util.getEdges = function() {
    var allNodes = Magellan.Util.getAllNodes(window.graph);
    var nodeNamesToNodes = Magellan.Util.getNodeNamesToNodesMap();
    var edges = [];
    _.each(allNodes, function(node){
    	edges = edges.concat(_.map(_.select(_.uniq(_.map(node.nodeInfo.edges,function(e){return e.target})),function(el){return el !== -1 && el !== null && el!== undefined}), function(target) {return{"target" : nodeNamesToNodes[target], "source" : node}} ));
    });
    return edges;
 };

   Magellan.Util.getEdgesFromJSON = function(graphJSON) {
      var allNodes = Magellan.Util.constructGraphFromJSON(graphJSON);
      var nodeNamesToNodes = Magellan.Util.getNodeNamesToNodesMapFromJSON(graphJSON);
      var edges = [];
      _.each(allNodes, function(node){
        edges = edges.concat(_.map(_.select(_.uniq(_.map(node.nodeInfo.edges,function(e){return e.target})),function(el){return el !== -1 && el !== null && el!== undefined}), function(target) {return{"target" : nodeNamesToNodes[target], "source" : node}} ));
      });
      return edges;
   };

  Magellan.Util.getTriggerNodeNames = function(nodeNamesToNodesMap) {
    var triggerNodeNamesToTriggerNodesMap = _.filter(nodeNamesToNodesMap, function(node, nodeName) {
      return (node instanceof Magellan.Models.TriggerNode);
    });
    var triggerNodeNames = _.map(triggerNodeNamesToTriggerNodesMap, function(node) {
      return node.nodeInfo.name;
    });
    return triggerNodeNames;
  };

  Magellan.Util.getStartNodeNames = function(nodeNamesToNodesMap) {
    var startNodeNames = { 'TriggerNode': [], 'RerouteNode': [] };
    _.each(nodeNamesToNodesMap, function(node, nodeName) {
      if (node instanceof Magellan.Models.TriggerNode) { 
        startNodeNames['TriggerNode'].push(node.nodeInfo.name); 
      } else if (node instanceof Magellan.Models.RerouteNode) {
        startNodeNames['RerouteNode'].push(node.nodeInfo.name);
      }
    });
    return startNodeNames;
  };

  Magellan.Util.getEdgeName = function(node, edgeName) {
    var nameToEdgeMap = node.getNameToEdgeMap();
    var edge = nameToEdgeMap[edgeName];
    if (node.nodeInfo.type === 'MATCH' || node.nodeInfo.type === 'DECISION') {
      var showEndOfFlow = false;
      _.each(node.getNameToEdgeMap(), function(edgeInfo) {
        if (edgeInfo.target === -1 && node.edgeToMetrics[edgeInfo.name] !== undefined) {
          showEndOfFlow = true;
        }
      });
      if (showEndOfFlow) {
        return 'End Of Flow';
      }
    }
    if ( edge && edge.target === -1 && edge.name === 'Next Node') {
      return node.nodeInfo.name;
    } else if ( (edge && edge.target !== -1) || (node.nodeInfo.actionType === 'Round Robin')) {
      return Magellan.Migration.getFormattedEdgeName(edge.name);
    } else {
      return node.getDefaultName(true);
    }
  };

  // Returns BFS order of node names that have a path from trigger node
  Magellan.Util.getContiguousNodeNames = function(nodeNamesToNodesMap, startNodeNames) {
    function BFS(orderedSeenNodes, frontierNodeNames) {
      if (frontierNodeNames.length === 0) {
        return orderedSeenNodes;
      } else {
        orderedSeenNodes = _.union(orderedSeenNodes, frontierNodeNames);
        var frontierNodes = _.map(frontierNodeNames, function(frontierNodeName) {
          return nodeNamesToNodesMap[frontierNodeName];
        });
        var nextFrontierNodeNames = _.uniq(_.flatten(_.map(frontierNodes, function(frontierNode) {
          return _.map(frontierNode.nodeInfo.edges, function(frontierNodeEdge) {
            return frontierNodeEdge.target;
          });
        })));
        var goodFlowNodeNames = _.filter(nextFrontierNodeNames, function(nextFrontierNodeName) {
          return !_.isNull(nextFrontierNodeName) && !_.isUndefined(nextFrontierNodeName) && nextFrontierNodeName !== -1 && nextFrontierNodeName !== 0;
        });
        var notSeenFrontierNodeNames = _.difference(goodFlowNodeNames, orderedSeenNodes);
        return BFS(orderedSeenNodes, notSeenFrontierNodeNames);
      }
    }
    return BFS([], startNodeNames);
  };

  Magellan.Util.getIntersectionFromAngle = function (imageString, angleInDegrees) {

    var granularity = 3600;

    angleInDegrees = angleInDegrees % 360;
    var mapIndex = Math.round(angleInDegrees * granularity / 360);
    imageString = imageString.toLowerCase();

    if (imageString === "action") {
      return Magellan.Util.actionAuxMap[mapIndex];
    } else if (imageString === "decision") {
      return Magellan.Util.decisionMap[mapIndex];
    } else if (imageString === "match") {
      return Magellan.Util.matchMap[mapIndex];
    } else if (imageString === "trigger") {
      return Magellan.Util.triggerMap[mapIndex];
    } else if (imageString === "reroute") {
      return Magellan.Util.rerouteAuxMap[mapIndex];
    } else if (imageString === 'partner') {
      return Magellan.Util.partnerAuxMap[mapIndex];
    } else {
	    return undefined;
    }
  };

  Magellan.Util.getAngleForLinkAndNode = function (link, node) {
  	var isSourceNode = node.id == link.get("source").id;
  	
  	var nodeCenter = node.getAbsoluteCenter();
  	var x1 = nodeCenter.x;
  	var y1 = nodeCenter.y;
  	if (!x1 || !y1) console.log(" " + x1 + " " + y1);
  	// var y1 = nodeCenter.y;

  	var linkTerminus = isSourceNode ? (link.get("target").id ? link.getTargetElement().getAbsoluteCenter() : link.get("target")) : (link.get("source").id ? link.getSourceElement().getAbsoluteCenter() : link.get("source"));
  	var x2 = linkTerminus.x;
  	var y2 = linkTerminus.y;
  	if (!x2 || !y2) console.log(" " + x2 + " " + y2);


  	var angle	= Math.atan((y1-y2)/(x2-x1))/(Math.PI/180);

  	angle = (angle - 90) * -1;

  	if (x2 < x1) angle += 180;
  	else if (y2 < y1) angle += 360;

  	return angle;
  };

  Magellan.Util.getLinkConnectionPoint = function (linkCell, nodeCell) {
  	var link = linkCell.model;
  	var node = nodeCell.model;
  	var absoluteCenter = node.getAbsoluteCenter();
  	// var absoluteCenter = node.position();

  	var isSourceNode = node.id == link.get("source").id;

  	// if (!isSourceNode) {
  		var nodeType;

	  	if (node instanceof Magellan.Models.ActionNode) {
	  		nodeType = "action";
	  	} else if (node instanceof Magellan.Models.TriggerNode) {
	  		nodeType = "trigger";
	  	} else if (node instanceof Magellan.Models.MatchNode) {
	  		nodeType = "match";
	  	} else if (node instanceof Magellan.Models.DecisionNode) {
	  		nodeType = "decision";
	  	} else if (node instanceof Magellan.Models.RerouteNode) {
	  	  nodeType = 'reroute';
	  	} else if (node instanceof Magellan.Models.OutreachNode || node instanceof Magellan.Models.SalesloftNode) {
	  	  nodeType = 'partner';
      }

      var angle = Magellan.Util.getAngleForLinkAndNode(link, node);
  		if (!angle) console.log("angle = " + angle);
		var offset;
			// temporary hack around extra triggernode which is !instanceof Magellan.Models.Node
		if (nodeType) {
      offset = Magellan.Util.getIntersectionFromAngle(nodeType, angle);
		}
      if (!offset) console.log("offset = " + offset);

      offset = offset || [0,0];
  		if (node instanceof Magellan.Models.RerouteNode) {
  		  // the reason ReRouteNode has different logic here, because the auxMap generated 
        // for RerouteNode image was using a 1:1 image size with the one used in the flowbuilder paper
        // versus what I guess happened was that Curtis was using a image twice the size of the one in flowbuilder for other nodes
        // then uses redefine the images size in the code. Therefore here, he as use offset/2 for previous nodes
        return g.point(absoluteCenter.x + offset[0], absoluteCenter.y + offset[1]);
      } else {
        return g.point(absoluteCenter.x + offset[0]/2, absoluteCenter.y + offset[1]/2);
      }
  	// } else {
  	// 	return g.point();
  	// }
  	
  };

  // For future uses
  Magellan.Util.scaleCoordinates = function (intersectionFunction, scale) {
    return function(imageString, angleInDegrees) {
      var intersectionCoordinate = intersectionFunction(imageString, angleInDegrees);
      return intersectionCoordinate.map(function(coordinateValue) {
        return Math.round(coordinateValue * scale);
      });
    };
	};

	Magellan.Util.measureText = function(text) {
		var dummyTspan = dummyTspan || document.getElementsByClassName("dummy-tspan")[0];
		dummyTspan.innerHTML = text;
		return dummyTspan.getComputedTextLength();
	};

	Magellan.Util.breakLabelText = function (text) {
		return Magellan.Util.wrapText(text, 5, 120).join("\n");
	};

	Magellan.Util.wrapText = function (text, numLines, lineWidth, dummyTspan) {
        var words = text.split(' ');
        var textLines = [];
        var i = 0;
        var j = 0;
        while (i < words.length) {
            if (_.isEmpty(textLines[j])) {
                textLines[j] = words[i++];
                continue;
            }

            var tmp = textLines[j] + words[i];
            var brokenText = joint.util.breakText(tmp, {width: lineWidth});
            if (brokenText === tmp) {
                textLines[j] += ' ' + words[i++];
            } else {
                textLines[++j] = words[i++];
            }
        }

        if (textLines.length > numLines) textLines[numLines - 1] += '...';
        return textLines.slice(0, numLines);
	};

  Magellan.Util.formatDate = function(dateVal) {
    dateObj = new Date( dateVal );
    if( dateObj == 'Invalid Date' )     
      return '';       
    var dateStr = pad2(dateObj.getUTCMonth()+1) + '/' + pad2(dateObj.getUTCDate()) + '/'  + dateObj.getUTCFullYear();
    return dateStr;
  };

	Magellan.Util.getBrokenWord = function (word, width, dummyTspan) {
		// var dummyTspan = dummyTspan || document.getElementsByClassName("dummy-tspan")[0];
		var currentLength = 0;

		var tokenLength = 0;
		while (currentLength < width) {
			currentLength = Magellan.Util.measureText(word.slice(0, tokenLength));
			// dummyTspan.innerHTML = word.slice(0, tokenLength);
			// currentLength = dummyTspan.getComputedTextLength();
			if (currentLength < width) tokenLength++;
		}

		return [word.slice(0,tokenLength), word.slice(tokenLength, word.length)];
	};

    Magellan.Util.identifyToken = function (token) {
        if (Number.isInteger(token) || (!isNaN(parseInt(token)) && String(parseInt(token)) === token)) {
            return "Integer";
        } else if (token === "(") {
            return "Open Parenthesis";
        } else if (token == ")") {
            return "Close Parenthesis";
        } else if (token === " ") {
            return "White Space";
        } else if (typeof token === "string" && (token.toUpperCase() === "AND" || token.toUpperCase() === "OR")) {
            return "Logical Operator";
        } else {
            return "Unknown";
        }
    };

    // Helper method takes in an Integer highestValidNumber and
    // and a String logicFormula
    // Converts logicFormula into a list of tokens and returns an object containing the following:
    // tokens => List of tokens obtained by tokenizing logicFormula
    // feedbackMessage => Error messages generated from trying to tokenize logicFormula
    Magellan.Util.tokenize = function(highestValidNumber, logicFormula) {

        // Add a whitespace to the back of logicFormula to flush cleanly
        logicFormula += " ";

        var tokenizedObject = {};
        tokenizedObject.tokens = [];
        tokenizedObject.feedbackMessage = [];

        var expectingTokenTypes = ["Open Parenthesis", "Integer"];
        var tokenBuffer = "";
        var currentToken = "";
        var tokenType = undefined;
        var seenRulesSet = [];

        for (var counter = 0; counter < logicFormula.length; counter++) {
            currentToken = logicFormula[counter];
            tokenType = Magellan.Util.identifyToken(currentToken);

            if (tokenType === "Open Parenthesis" || tokenType === "Close Parenthesis" || tokenType === "White Space") {
                // Handle tokens in token buffer first
                if (tokenBuffer.length > 0) {
                    tokenType = Magellan.Util.identifyToken(tokenBuffer);

                    // Checks if this tokenBuffer is expected
                    if (expectingTokenTypes.includes(tokenType)) {
                        if (tokenType === "Open Parenthesis" || tokenType === "Logical Operator") {
                            expectingTokenTypes = ["Open Parenthesis", "Integer"];
                        } else if (tokenType === "Close Parenthesis" || tokenType === "Integer") {
                            expectingTokenTypes = ["Close Parenthesis", "Logical Operator"];
                        }
                    } else {
                        tokenizedObject.feedbackMessage.push("Expecting " + expectingTokenTypes.join("/") + " but got " + tokenBuffer);
                    }

                    // Also check if number does not exceed
                    if (tokenType === "Integer") {
                        var integerToken = parseInt(tokenBuffer, 10);
                        if (integerToken > 0 && integerToken <= highestValidNumber) {
                            if (!seenRulesSet.includes(integerToken)) {
                                seenRulesSet.push(integerToken);
                            }
                            tokenizedObject.tokens.push(integerToken);
                            tokenBuffer = "";
                        } else {
                            tokenizedObject.feedbackMessage.push("No such condition: " + tokenBuffer);
                        }
                    } else {
                        tokenizedObject.tokens.push(tokenBuffer.toUpperCase());
                        tokenBuffer = "";
                    }
                    tokenType = Magellan.Util.identifyToken(currentToken);
                }

                // After handling tokens in token buffer, handle current token
                // Don't push white space into input tokens
                if (tokenType !== "White Space") {
                    if (tokenType === "Open Parenthesis" && expectingTokenTypes.includes(tokenType)) {
                        expectingTokenTypes = ["Open Parenthesis", "Integer"];
                    } else if (tokenType === "Close Parenthesis" && expectingTokenTypes.includes(tokenType)) {
                        expectingTokenTypes = ["Close Parenthesis", "Logical Operator"];
                    } else {
                        tokenizedObject.feedbackMessage.push("Expecting " + expectingTokenTypes.join("/") + " but got " + currentToken);
                    }
                    tokenizedObject.tokens.push(currentToken);
                    currentToken = "";
                }
            } else {
                tokenBuffer += currentToken;
            }
        }

        // Check if all rules are present
        if (seenRulesSet.length < highestValidNumber) {
            tokenizedObject.feedbackMessage.push("Not all rules have been included in logic yet!");
        }
        return tokenizedObject;
    };

    // Helper method takes a list of tokens and processes
    // it to its RPN form
    // Returns an object containing the following:
    // RPNTokens => List of tokens in RPN form
    // hasUnknownTokens => Boolean value that is true if unknown tokens were encountered
    // hasMismatchedParenthesis => Boolean value that is true if there is a parenthesis mismatch in formula
    Magellan.Util.dijkstraShuntingYard = function (tokens) {

        var stack = [];
        var currentToken = undefined;
        var currentTokenType = undefined;

        var dijkstraObject = {};
        var RPNTokens = [];
        var hasUnknownTokens = false;
        var hasMismatchedParenthesis = false;

        for (var counter = 0; counter < tokens.length; counter++) {
            currentToken = tokens[counter];
            currentTokenType = Magellan.Util.identifyToken(currentToken);

            // If number: push to RPNTokens
            // If operator: pop operator(s) in stack and push this to stack
            // If left parenthesis: push to stack
            // If right parenthesis: pop until left parenthesis
            if (currentTokenType === "Integer") {
                RPNTokens.push(currentToken);
            } else if (currentTokenType === "Logical Operator") {
                // Stop popping if found parenthesis
                while (stack.length > 0) {
                    var nextTokenType = Magellan.Util.identifyToken(stack[stack.length - 1]);
                    if (nextTokenType === "Logical Operator") {
                        RPNTokens.push(stack.pop());
                    } else {
                        break;
                    }
                }
                stack.push(currentToken);
            } else if (currentTokenType === "Open Parenthesis") {
                stack.push(currentToken);
            } else if (currentTokenType === "Close Parenthesis") {
                var foundMatching = false;
                while (stack.length > 0 && !foundMatching) {
                    var poppedToken = stack.pop();
                    var poppedTokenType = Magellan.Util.identifyToken(poppedToken);
                    if (poppedTokenType === "Open Parenthesis") {
                        foundMatching = true;
                    } else {
                        RPNTokens.push(poppedToken);
                    }
                }
                if (stack.length === 0 && !foundMatching) {
                    hasMismatchedParenthesis = true;
                }
            } else {
                hasUnknownTokens = true;
            }
        }
        // Pop remaining tokens from stack to RPNTokens
        while (stack.length > 0) {
            var poppedToken = stack.pop();
            var poppedTokenType = Magellan.Util.identifyToken(poppedToken);
            if (poppedTokenType === "Open Parenthesis" || poppedTokenType === "Close Parenthesis") {
                hasMismatchedParenthesis = true;
            } else {
                RPNTokens.push(poppedToken);
            }
        }

        dijkstraObject["RPNTokens"] = RPNTokens;
        dijkstraObject["hasMismatchedParenthesis"] = hasMismatchedParenthesis;
        dijkstraObject["hasUnknownTokens"] = hasUnknownTokens;

        return dijkstraObject;
    };

    // Function takes in an Integer highestValidNumber
    // and a String logicFormula
    // Returns an object that contains the following:
    // token => logicFormula in tokenized form
    // RPNTokens => logicFormula in Reverse Polish Notation form
    // feedbackMessage => Contains all the error messages generated from processing logicFormula
    Magellan.Util.parseLogic = function (highestValidNumber, logicFormula) {
        var parsedFormulaObject = {};
        parsedFormulaObject.tokens = undefined;
        parsedFormulaObject.RPNTokens = undefined;
        parsedFormulaObject.feedbackMessage = [];

        var tokenizedObject = Magellan.Util.tokenize(highestValidNumber, logicFormula);
        parsedFormulaObject.tokens = tokenizedObject.tokens;
        parsedFormulaObject.feedbackMessage = parsedFormulaObject.feedbackMessage.concat(tokenizedObject.feedbackMessage);

        var dijkstraObject = Magellan.Util.dijkstraShuntingYard(parsedFormulaObject.tokens);
        parsedFormulaObject.RPNTokens = dijkstraObject.RPNTokens;
        if (dijkstraObject.hasMismatchedParenthesis) {
            parsedFormulaObject.feedbackMessage.push("Parenthesis mismatch found!");
        }
        if (dijkstraObject.hasUnknownTokens) {
            parsedFormulaObject.feedbackMessage.push("Unknown tokens found in formula!");
        }
        if (parsedFormulaObject.tokens.length > 0 && Magellan.Util.identifyToken(_.last(parsedFormulaObject.tokens)) === "Logical Operator") {
            parsedFormulaObject.feedbackMessage.push("Cannot end with a logical operator!");
        }

        return parsedFormulaObject;
    };

    Magellan.Util.formatTupleCriterionHtml = function(criterion) {
      var result = '';
      var feedbackMessages = Magellan.Util.parseLogic(criterion.conditions.length, criterion.logic).feedbackMessage;
      if (feedbackMessages.length === 0) {
        var tokenizedLogic = Magellan.Util.tokenize(criterion.conditions.length, criterion.logic).tokens;
        _.each(tokenizedLogic, function(token) {
          var tokenType = Magellan.Util.identifyToken(token);
          if (tokenType === "Integer") {
            var cond = criterion.conditions[token - 1]; 
            var condField = cond.field;
            // var condField = getFieldLabel(cond["field"]);
            var condOperator = cond.operator;
            var condOperand = cond.operand;
            // var condOperand = cond['value/field'] === 'field' ? getOperandFieldLabel(cond.operand) : getOperandValueLabel(cond);
            result += '<span class="ld-green">[' + condField + '</span> ' + condOperator + ' <span class="ld-green">' + condOperand + ']</span>';
          } else if (tokenType === "Logical Operator") {
            result += '<span> ' + token + ' </span>';
          } else {
            result += '<span>' + token + ' </span>';
          }
        });
      } else {
        result = feedbackMessages.join("\n");
      }
      return result;
    };

    Magellan.Util.flattenReferenceLabels = function(label) {
    	return label.replace(' ID', '');
    };

    Magellan.Util.flattenReferenceAPIs = function(apiName) {
    	var newApiName = apiName.replace(new RegExp('__c$'), '__r');	
		if (newApiName === apiName) {
			newApiName = newApiName.replace(new RegExp('id$'), '');
		}
		return newApiName;
    };

    Magellan.Util.createFlattenedFields = function(fields) {
		var flattenedFields = _.map(fields, function(field) {
		    return Magellan.Util.flattenField(field); 
		});
		return flattenedFields;
    };
    
    Magellan.Util.flattenField = function(field) {
        var copy = {};
        $.extend(true, copy, field);
        if (copy.type == "REFERENCE") {
            copy.type = "ID";
//            copy.parent = [];
        }
        
        return copy;
    }

	Magellan.Util.capitalizeString = function(string) {
		return string.charAt(0).toUpperCase() + string.slice(1).toLowerCase();
	};
	
	Magellan.Util.unset = function(obj) {
	    for (var key in obj) delete obj[key]; // mutate the object
        return obj;
    };
    
    Magellan.Util.getFieldFromAPIName = function(fieldName, metadataMap){
        return _.filter(metadataMap, function(obj){
            return  obj.name === fieldName;
        })
    }
  /**
   * Filter typeahead results
   * Assumption - data in results already lowercase
   */
  Magellan.Util.filterTypeaheadResults = (results, searchTerm) => {
    if (searchTerm === undefined || searchTerm === null) {
      searchTerm = '';
    }
    searchTerm =  searchTerm.toLowerCase();
    const filteredResults = {
      'prefix': [],
      'substring': [],
      'id': [],
    };
    results.forEach((datum) => {
      const name = datum.label.toLowerCase();
      if (name.startsWith(searchTerm)) {
        filteredResults.prefix.push(datum);
      } else if (name.indexOf(searchTerm) >= 0) {
        filteredResults.substring.push(datum);
      } else if (datum.id === searchTerm) {
        filteredResults.id.push(datum);
      }
    });
    return [].concat(
      filteredResults.prefix,
      filteredResults.substring,
      filteredResults.id
    );
  };
  //used for simple typeahead without multiple parent child relationships
  Magellan.Util.convertStringSelectionToArray = function (strValue) {
    if (_.isEmpty(strValue)) return [];
    return [{"label": strValue,"name": strValue}];
  };
	Magellan.Util.convertFieldSelectionStringToArray = function(fields, objectName, metadataMap) {
        if (typeof fields === 'string' && fields !== "") fields = fields.toLowerCase().split('.');
        if (_.isEmpty(fields)) return [];
        var fieldName = fields[0];
        var selections = [];
        
        // possibleFieldNames: as-is, id field, or custom field
        var possibleFieldNames = [fieldName, fieldName + "id", fieldName.replace(new RegExp("__r$"), "__c")];

        var foundField = null;
        var fieldsMap = metadataMap[objectName];

        // If fieldsMap is an array, create map from it, typically used if you feed fieldMetaData as the argument for metadataMap
        if (_.isArray(fieldsMap)) fieldsMap = _.indexBy(fieldsMap, 'name');

        for (var i = 0; i < possibleFieldNames.length; i++) {
            if (foundField = fieldsMap[possibleFieldNames[i]]) {
                selections.push(foundField);
                break;
            }
        }

        if (!foundField) {
            var err = { message: "Warning: field " + fields + " not found for object " + objectName + " in dataset. Previous value is probably not the same type as items in the dataset. Ignore this message if that's the case." };
            err['context'] = { "Fields": fields, "Dataset": metadataMap };
            console.warn(err);
        } else if (foundField.hasOwnProperty('parent') && foundField['parent'].length > 0) {
            _.each(foundField.parent, function(parentObjectName) {
                var subFields = Magellan.Util.convertFieldSelectionStringToArray(fields.slice(1), parentObjectName, metadataMap);
                Array.prototype.push.apply(selections, subFields);
                if (subFields && subFields.length > 0) return false;
            });
        }

        return selections;
    }
    
    Magellan.Util.convertFieldSelectionArrayToString = function(fieldsArray) {
	    var lastSelection = fieldsArray[fieldsArray.length - 1], stringValue = '';
        if (_.isUndefined(lastSelection) || lastSelection.type === 'REFERENCE') return stringValue; 

        var stringValue = fieldsArray.reduce(function(str, field) {
            if (str!== "") str += ".";

            if (field.type === 'REFERENCE')
                return str += Magellan.Util.flattenReferenceAPIs(field.name);
            else
                return str += field.name;
        }, "");
        
        return stringValue;
	}

  Magellan.Util.getObjectTypeFromCurrentSuggestions = function(suggestions) {
    if (suggestions.length === 0) return null;
    let type;
    for (let i = 0; i < suggestions.length; i++) {
      if (suggestions[i].objectType) {
        type = suggestions[i].objectType;
        break;
      }
    }
    return type;
  }

  Magellan.Util.createBlacklistFilter = function (objectType, field='name') {
    return function(suggestions){
      var blacklistFieldName = objectType ? objectType.toUpperCase() + '_FIELDS' : '';
      var hasBlacklist = !!Magellan.Validation.FIELD_BLACKLIST_SETS[blacklistFieldName];
      return _.filter(suggestions, function(suggestion) {
        return !hasBlacklist ? true : !Magellan.Validation.FIELD_BLACKLIST_SETS[blacklistFieldName].has(suggestion[field]);
      });
    }
  }
    
    Magellan.Util.createFieldsFilter = function(fieldType) {
	    return function(suggestions) {
            return _.filter(suggestions, function(suggestion) {
                if (!suggestion['type']) return false;
                var valid = Magellan.Validation.SFDC_TYPE_TO_GROUPING[suggestion['type']] === fieldType;
                valid = valid || suggestion['type'] === 'REFERENCE';

                return valid;
            });
        }
    }

    /* 
     * Use with nestedTypeahead 'filter option'
     * returns: list of items to be shown by typeahead search
     * @itemsToExclude: array of values [a,b,c, ... ] 
     * @propertyToCheck: typeahead items are objects in the form:
     * {
          'name' : 'example name'
          'label' : 'example label'
     * }
     * only label and name are needed for typeahead to function but often there are
     * other included keys like 'Id'. this parameter chooses one of these fields to check
     * against itemsToExclude
     */
    Magellan.Util.typeaheadDataFilter = function(itemsToExclude, propertyToCheck) {
      return function(suggestions) {
            return _.filter(suggestions, function(suggestion) {
                let isValid = !_.isEmpty(suggestion[propertyToCheck]);
                return isValid && !(itemsToExclude.includes(suggestion[propertyToCheck]));
            });
        }
    }
    
    // Kyle's Mapping Page and Validation Rework 10/16/2017
    // This will filter the fields based on the new SFDC_VALID_TYPE_MAPPING object
    // This is a single direction mapping filter that will only allow fields on the right dropdown
    // to show if they are valid mappings.
    // Currently only used on the Mapping Page, but will be extended to Update Lead Node
    Magellan.Util.createMappingFieldsFilter = function(selectedField){
        var validFieldTypes = (selectedField) ? Magellan.Validation.SFDC_VALID_TYPE_MAPPING[selectedField['type']] : [];
        var objectTypes = (selectedField) ? selectedField['objectType'].split('/') : []; // Handles Group/User types
        return function(suggestions) {
            return _.filter(suggestions, function(suggestion){
               var isSameType = validFieldTypes.includes(suggestion['type']) || false;
               
                if(suggestion['type'] === 'REFERENCE')
                    return true;
                    
                else if(isSameType && (suggestion['type'] != 'ID' ||  !_.isEmpty(_.intersection(suggestion['parent'], objectTypes))))
                    return true;
                else
                    return false;
            });            
        }
    }

    Magellan.Util.createMappingFlattenedFieldsFilter = function(selectedField){
        var validFieldTypes = [];
        var selectedObjectTypes = [];
        
        if (selectedField) {
          validFieldTypes = Magellan.Validation.SFDC_VALID_TYPE_MAPPING[selectedField['type']];
          selectedObjectTypes = selectedField['objectType'].split('/');
        }

        // console.log('selected field', selectedField)
        // console.log('validFieldTypes', validFieldTypes);
        // console.log('selectedObjectTypes', selectedObjectTypes);
        return function(suggestions) {
            return _.filter(suggestions, function(suggestion){
              // Always make sure the type of each field is the same, otherwise return false
              var isSameType = validFieldTypes.includes(suggestion.type);
              
              if (selectedField.parent.length > 0 && suggestion.parent.length > 0) {
                // If selectedField AND suggestion have parents (both fields were REF before flattened)
                // Compare parents
                var hasSameParent = false;
                selectedField.parent.forEach( function(selectedParent) {
                  suggestion.parent.forEach( function(currentParent) {
                    if (selectedParent == currentParent) hasSameParent = true;
                  })
                })
                return isSameType && hasSameParent;
              } else if (selectedField.parent.length > 0 && suggestion.parent.length == 0) {
                // If selectedField has parents (REF) and suggestion DOESN'T have parents
                // Compare selectedField parents to the suggestion objectType
                var suggestionTypeInSelectedParent = selectedField.parent.includes(suggestion.objectType);
                return isSameType && suggestionTypeInSelectedParent
              } else if (selectedField.parent.length == 0 && suggestion.parent.length > 0) {
                // If selectedField DOESN'T have parents and suggestion has parents (REF)
                // Compare the selectedField objectType to the suggestion parents
                var selectedTypeInSuggestionParent = suggestion.parent.includes(selectedField.objectType);
                return isSameType && selectedTypeInSuggestionParent;
              } else {
                // If neither selectedField or suggestion have parents
                // Compare the objectTypes of both fields
                var isSameObjectType = selectedObjectTypes.includes(suggestion.objectType)
                return isSameType && (suggestion.type != 'ID' || isSameObjectType) ? true : false;
              }
             
            });            
        }
    }
    
    Magellan.Util.createUserFieldsFilter = function() {
	    return function(suggestions) {
            return _.filter(suggestions, function(suggestion) {
                return suggestion['type'] === 'REFERENCE' || (suggestion['objectType'] === 'User' && suggestion.name === 'id');
            });
        }
    }
    
    Magellan.Util.createFlattenedUserFieldsFilter = function(){
        return function(suggestions) {
            return _.filter(suggestions, function(suggestion){
                return suggestion['parent'].includes('User');
            })
        }
    }

    Magellan.Util.createOwnerToOwnerMappingFilter = function() {
        return function (suggestions) {
            return _.filter(suggestions, function (suggestion) {
                if (suggestion['objectType'] ==='Group' || suggestion['objectType'] ==='Group/User') {
                  return !Magellan.Validation.FIELD_BLACKLIST_SETS['GROUP_FIELDS'].has(suggestion['name']);
                } else if (suggestion['objectType'] === 'User') {
                  return !Magellan.Validation.FIELD_BLACKLIST_SETS['USER_FIELDS'].has(suggestion['name']);
                } else {
                    return true;
                }
            })
        }
    }

    // Generic
    Magellan.Util.construct_parsed_condition = function(unparsed_condition_object) {
        var condition_type = unparsed_condition_object["type"];
        var parsed_condition_string = "";
        if (condition_type === "conditions") {
            var textLogic = unparsed_condition_object["logic"];

            if (typeof textLogic === "undefined" || textLogic === null) {
                parsed_condition_string = "<b>No Logic For Filter Condition</b>";
            } else {
                for (var i = 1; i <= unparsed_condition_object["conditions"].length; i++) {
                    var chosen_condition = unparsed_condition_object["conditions"][i - 1];
                    var conditionOps = [chosen_condition["field"], chosen_condition["operator"], chosen_condition["operand"]];
                    var conditionText = conditionOps.join(" ");
                    var logicTokenRegExp = new RegExp('\\b' + i + '\\b'); // replace whole word (e.g. replace "1", not "11" as two of "1")
                    textLogic = textLogic.replace(logicTokenRegExp, conditionText);
                }

                parsed_condition_string = '(' + textLogic + ')';
            }
        } else if (condition_type === "soql") {
            parsed_condition_string = unparsed_condition_object["soqlCondition"];
        } else if (condition_type === "optima") {
            parsed_condition_string = unparsed_condition_object["direction"] + " " + unparsed_condition_object["field"];
        }
        return parsed_condition_string;
	}
	
    Magellan.Util.getPluralObjectName = function(singular) {
	    if (singular === 'Opportunity') return 'Opportunities';
	    else return singular + 's';
    }

    // Grab parameters from URL
    Magellan.Util.getUrlParams = function() {
      var args = Array.prototype.slice.call(arguments);

      var parameters = {};
      location.search.substr(1).split("&").forEach(function(item) {
        var param = item.split("=");
        parameters[param[0]] = param[1];
      });

      Array.prototype.slice.call(arguments).forEach(function(arg) {
        parameters[arg[0]] = arg[1];
      })
      
      return parameters;
    }

    Magellan.Util.checkIfReadOnlyGraph = function() {
	    return magellanPage.includes("deploymentMetrics") || magellanPage.includes("deploymentHistory");
    }

    // Get string version of nested dropdown field options, then return an array of actual field objects
    Magellan.Util.expandNestedDropdownFieldSelections = function(selectionsString, startType, fields) {
      var selections = [];
      if (!selectionsString || selectionsString.length === 0) return selections;

      var selectionNames = _.map(selectionsString.split('.'), function(selection) { return selection.replace(new RegExp("__r$"), "__c") })

      _.each(selectionNames, function(name) {
        var match1 = _.find(fields[startType], 'name', name.toLowerCase());
        var match2 = _.find(fields[startType], 'name', name.toLowerCase() + "id");
        var match = match1 || match2;
        if (match) {
          selections.push(match);
          if (match.type === "REFERENCE") {
            startType = match.parent[0];
          }
        }
      })
      return selections;
    }
    
    Magellan.Util.convertMSToHoursMinutes = function(milliseconds){
      minutes = Math.floor(milliseconds / 1000 / 60);
      hours = Math.floor(minutes / 60);
      minutes = minutes % 60;
          
      return (hours < 10 ? '0' + hours : hours) + ':' + (minutes < 10 ? '0' + minutes : minutes);
  	}
    
    Magellan.Util.convertSecondsToHoursMinutes = function(seconds) {
      minutes = Math.floor(seconds / 60);
      hours = Math.floor(minutes / 60);
      minutes = minutes % 60;
          
      return (hours < 10 ? '0' + hours : hours) + ':' + (minutes < 10 ? '0' + minutes : minutes);
    }

    Magellan.Util.formatMomentDate = function(date, format, noOffset) {
      var offset = noOffset ? 0 : new Date().getTimezoneOffset() * 60000;
      var formattedDate = new Date(new Date(date).getTime() - offset);
      return moment(formattedDate).format(format || 'MM/DD/YYYY, h:mm:ss A');
    }
    
    Magellan.Util.convertTo12Hr = function(str) {
      var hour = str.split(':')[0]; var min = str.split(':')[1];

      var suffix = (hour >= 12) ? 'pm' : 'am';
      var newHour = (hour > 12) ? hour - 12 : hour;
      newHour = (newHour === 0) ? 12 : newHour;

      return String(newHour).padStart(2, '0') + ':'  + min + ' ' + suffix;
    }
    Magellan.Util.initializeTooltip = function($elem, options) {
      var fadeDuration = 100;
      var tooltipHtml = _.template(require('../templates/tooltip.html')) ({
        title: options.title,
        body: options.body
      });
      var $tooltip = $(tooltipHtml).appendTo($elem);
      $elem.click(function(d) {
        $('.dg_inner-wrapper .ld-tooltip').not($tooltip).fadeOut(fadeDuration);
        if(!$(d.target).hasClass('ld-tooltip-close-icon')) {
          $tooltip.fadeIn(fadeDuration);
        }
      });
      $tooltip.find('.ld-tooltip-close-icon').click(function(d) { $tooltip.fadeOut(fadeDuration); });
      $('.dg_inner-wrapper').click(function(e) {
        if(!$(e.target).closest('.ld-tooltip-hint').length) {
          $('.ld-tooltip').fadeOut(fadeDuration);
        }
      });
    }

    Magellan.Util.formatDateToUTCWithTimezoneOffset = function(datetime, timezoneId) {
      // Expecting datetime format 'YYYY-MM-DD HH:mm:ss' and timezoneId from below 
      var timezone = Magellan.Util.Timezones.idToTimezone[timezoneId];
      if (!_.isObject(timezone)) console.error('Invalid timezone Id: ' + timezoneId);
      var fullDatetime = moment(datetime).format('YYYY-MM-DDTHH:mm:ss') + timezone['gmtOffset']; // e.g: 2018-06-26T21:00:00-07:00 for America/Los_Angeles
      return moment(fullDatetime).utc().format(Magellan.Validation.DATETIME_FORMAT);
    }
    
    Magellan.Util.formatGMTDateTimeToTimezone = function(gmtDateTime, desiredTimezoneId, format) {
      var timezone = Magellan.Util.Timezones.idToTimezone[desiredTimezoneId];
      if (!_.isObject(timezone)) console.error('Invalid timezone Id: ' + desiredTimezoneId);
      var gmtOffsetInMilliseconds = moment().utcOffset(timezone['gmtOffset'])._offset * 60 * 1000;
      var unixTime = moment.utc(gmtDateTime).valueOf() + gmtOffsetInMilliseconds;
      
      return moment.utc(unixTime).format(format || 'YYYY-MM-DD HH:mm:ss');
    }

    Magellan.Util.Timezones = { 
        idToName: {},
        idToTimezone: {},
        tokenizer: function(tzId) {
            var timezone = Magellan.Util.Timezones.idToTimezone[tzId];
            return Bloodhound.tokenizers.whitespace(timezone['name']).concat(tzId.split(/[/_]/));
        },
        datumTokenizer: function(datum) {
            return Bloodhound.tokenizers.nonword(datum['name'])
                  .concat(Bloodhound.tokenizers.whitespace(datum['name'] + ' ' + datum['id']));
        },
        guessUserTimezone: function() {
            try {
                return Intl.DateTimeFormat().resolvedOptions().timeZone || null;
            } catch(e) {
                console.error(e);
                return null;
            }
        }
    };
    Magellan.Util.Timezones.idToName = {
      //'members timezone': 'Member\'s Timezone',
      'Pacific/Kiritimati':'(GMT+14:00) Line Is. Time (Pacific/Kiritimati)',
      'Pacific/Enderbury':'(GMT+13:00) Phoenix Is.Time (Pacific/Enderbury)',
      'Pacific/Tongatapu':'(GMT+13:00) Tonga Time (Pacific/Tongatapu)',
      'Pacific/Chatham':'(GMT+12:45) Chatham Standard Time (Pacific/Chatham)',
      'Pacific/Auckland':'(GMT+12:00) New Zealand Standard Time (Pacific/Auckland)',
      'Pacific/Fiji':'(GMT+12:00) Fiji Time (Pacific/Fiji)',
      'Asia/Kamchatka':'(GMT+12:00) Petropavlovsk-Kamchatski Time (Asia/Kamchatka)',
      'Pacific/Norfolk':'(GMT+11:30) Norfolk Time (Pacific/Norfolk)',
      'Australia/Lord_Howe':'(GMT+11:00) Lord Howe Standard Time (Australia/Lord_Howe)',
      'Pacific/Guadalcanal':'(GMT+11:00) Solomon Is. Time (Pacific/Guadalcanal)',
      'Australia/Adelaide':'(GMT+10:30) Australian Central Standard Time ((South Australia) Australia/Adelaide)',
      'Australia/Sydney':'(GMT+10:00) Australian Eastern StandardTime (New South Wales) (Australia/Sydney)',
      'Australia/Brisbane':'(GMT+10:00) Australian Eastern Standard Time (Queensland) (Australia/Brisbane)',
      'Australia/Darwin':'(GMT+09:30) Australian Central Standard Time (Northern Territory) (Australia/Darwin)',
      'Asia/Seoul':'(GMT+09:00) Korea Standard Time (Asia/Seoul)',
      'Asia/Tokyo':'(GMT+09:00) Japan Standard Time (Asia/Tokyo)',
      'Asia/Hong_Kong':'(GMT+08:00) Hong Kong Time (Asia/Hong_Kong)',
      'Asia/Kuala_Lumpur':'(GMT+08:00) Malaysia Time (Asia/Kuala_Lumpur)',
      'Asia/Manila':'(GMT+08:00) Philippines Time (Asia/Manila)',
      'Asia/Shanghai':'(GMT+08:00) China Standard Time (Asia/Shanghai)',
      'Asia/Singapore':'(GMT+08:00) Singapore Time (Asia/Singapore)',
      'Asia/Taipei':'(GMT+08:00) China Standard Time (Asia/Taipei)',
      'Australia/Perth':'(GMT+08:00) Australian Western Standard Time (Australia/Perth)',
      'Asia/Bangkok':'(GMT+07:00) Indochina Time (Asia/Bangkok)',
      'Asia/Ho_Chi_Minh':'(GMT+07:00) Indochina Time (Asia/Ho_Chi_Minh)',
      'Asia/Jakarta':'(GMT+07:00) West Indonesia Time (Asia/Jakarta)',
      'Asia/Rangoon':'(GMT+06:30) Myanmar Time (Asia/Rangoon)',
      'Asia/Dhaka':'(GMT+06:00) Bangladesh Time (Asia/Dhaka)',
      'Asia/Kathmandu':'(GMT+05:45) Nepal Time (Asia/Kathmandu)',
      'Asia/Colombo':'(GMT+05:30) India Standard Time (Asia/Colombo)',
      'Asia/Kolkata':'(GMT+05:30) India Standard Time (Asia/Kolkata)',
      'Asia/Karachi':'(GMT+05:00) Pakistan Time (Asia/Karachi)',
      'Asia/Tashkent':'(GMT+05:00) Uzbekistan Time (Asia/Tashkent)',
      'Asia/Yekaterinburg':'(GMT+05:00) Yekaterinburg Time (Asia/Yekaterinburg)',
      'Asia/Kabul':'(GMT+04:30) Afghanistan Time (Asia/Kabul)',
      'Asia/Baku':'(GMT+04:00) Azerbaijan Summer Time (Asia/Baku)',
      'Asia/Dubai':'(GMT+04:00) Gulf Standard Time (Asia/Dubai)',
      'Asia/Tbilisi':'(GMT+04:00) Georgia Time (Asia/Tbilisi)',
      'Asia/Yerevan':'(GMT+04:00) Armenia Time (Asia/Yerevan)',
      'Asia/Tehran':'(GMT+03:30) Iran Daylight Time (Asia/Tehran)',
      'Africa/Nairobi':'(GMT+03:00) East African Time (Africa/Nairobi)',
      'Asia/Baghdad':'(GMT+03:00) Arabia Standard Time (Asia/Baghdad)',
      'Asia/Kuwait':'(GMT+03:00) Arabia Standard Time (Asia/Kuwait)',
      'Asia/Riyadh':'(GMT+03:00) Arabia Standard Time (Asia/Riyadh)',
      'Europe/Minsk':'(GMT+03:00) Moscow Standard Time (Europe/Minsk)',
      'Europe/Moscow':'(GMT+03:00) Moscow Standard Time (Europe/Moscow)',
      'Africa/Cairo':'(GMT+03:00) Eastern European Summer Time (Africa/Cairo)',
      'Asia/Beirut':'(GMT+03:00) Eastern European Summer Time (Asia/Beirut)',
      'Asia/Jerusalem':'(GMT+03:00) Israel Daylight Time (Asia/Jerusalem)',
      'Europe/Athens':'(GMT+03:00) Eastern European Summer Time (Europe/Athens)',
      'Europe/Bucharest':'(GMT+03:00) Eastern European Summer Time (Europe/Bucharest)',
      'Europe/Helsinki':'(GMT+03:00) Eastern European Summer Time (Europe/Helsinki)',
      'Europe/Istanbul':'(GMT+03:00) Eastern European Summer Time (Europe/Istanbul)',
      'Africa/Johannesburg':'(GMT+02:00) South Africa Standard Time (Africa/Johannesburg)',
      'Europe/Amsterdam':'(GMT+02:00) Central European Summer Time (Europe/Amsterdam)',
      'Europe/Berlin':'(GMT+02:00) Central European Summer Time (Europe/Berlin)',
      'Europe/Brussels':'(GMT+02:00) Central European Summer Time (Europe/Brussels)',
      'Europe/Paris':'(GMT+02:00) Central European Summer Time (Europe/Paris)',
      'Europe/Prague':'(GMT+02:00) Central European Summer Time (Europe/Prague)',
      'Europe/Rome':'(GMT+02:00) Central European Summer Time (Europe/Rome)',
      'Europe/Lisbon':'(GMT+01:00) Western European Summer Time (Europe/Lisbon)',
      'Africa/Algiers':'(GMT+01:00) Central European Time (Africa/Algiers)',
      'Europe/London':'(GMT+01:00) British Summer Time (Europe/London)',
      'Atlantic/Cape_Verde':'(GMT-01:00) Cape Verde Time (Atlantic/Cape_Verde)',
      'Africa/Casablanca':'(GMT+00:00) Western European Time (Africa/Casablanca)',
      'Europe/Dublin':'(GMT+00:00) Irish Summer Time (Europe/Dublin)',
      'GMT':'(GMT+00:00) Greenwich Mean Time (GMT)',
      'America/Scoresbysund':'(GMT-00:00) Eastern Greenland Summer Time (America/Scoresbysund)',
      'Atlantic/Azores':'(GMT-00:00) Azores Summer Time (Atlantic/Azores)',
      'Atlantic/South_Georgia':'(GMT-02:00) South Georgia Standard Time (Atlantic/South_Georgia)',
      'America/St_Johns':'(GMT-02:30) Newfoundland Daylight Time (America/St_Johns)',
      'America/Sao_Paulo':'(GMT-03:00) Brasilia Summer Time (America/Sao_Paulo)',
      'America/Argentina/Buenos_Aires':'(GMT-03:00) Argentina Time (America/Argentina/Buenos_Aires)',
      'America/Santiago':'(GMT-03:00) Chile Summer Time (America/Santiago)',
      'America/Halifax':'(GMT-03:00) Atlantic Daylight Time (America/Halifax)',
      'America/Puerto_Rico':'(GMT-04:00) Atlantic Standard Time (America/Puerto_Rico)',
      'Atlantic/Bermuda':'(GMT-04:00) Atlantic Daylight Time (Atlantic/Bermuda)',
      'America/Caracas':'(GMT-04:30) Venezuela Time (America/Caracas)',
      'America/Indiana/Indianapolis':'(GMT-04:00) Eastern Daylight Time (America/Indiana/Indianapolis)',
      'America/New_York':'(GMT-04:00) Eastern Daylight Time (America/New_York)',
      'America/Bogota':'(GMT-05:00) Colombia Time (America/Bogota)',
      'America/Lima':'(GMT-05:00) Peru Time (America/Lima)',
      'America/Panama':'(GMT-05:00) Eastern Standard Time (America/Panama)',
      'America/Mexico_City':'(GMT-05:00) Central Daylight Time (America/Mexico_City)',
      'America/Chicago':'(GMT-05:00) Central Daylight Time (America/Chicago)',
      'America/El_Salvador':'(GMT-06:00) Central Standard Time (America/El_Salvador)',
      'America/Denver':'(GMT-06:00) Mountain Daylight Time (America/Denver)',
      'America/Mazatlan':'(GMT-06:00) Mountain Standard Time (America/Mazatlan)',
      'America/Phoenix':'(GMT-07:00) Mountain Standard Time (America/Phoenix)',
      'America/Los_Angeles':'(GMT-07:00) Pacific Daylight Time (America/Los_Angeles)',
      'America/Tijuana':'(GMT-07:00) Pacific Daylight Time (America/Tijuana)',
      'Pacific/Pitcairn':'(GMT-08:00) Pitcairn Standard Time (Pacific/Pitcairn)',
      'America/Anchorage':'(GMT-08:00) Alaska Daylight Time (America/Anchorage)',
      'Pacific/Gambier':'(GMT-09:00) Gambier Time (Pacific/Gambier)',
      'America/Adak':'(GMT-9:00) Hawaii-Aleutian Standard Time (America/Adak)',
      'Pacific/Marquesas':'(GMT-09:30) Marquesas Time (Pacific/Marquesas)',
      'Pacific/Honolulu':'(GMT-10:00) Hawaii-Aleutian Standard Time (Pacific/Honolulu)',
      'Pacific/Niue':'(GMT-11:00) Niue Time (Pacific/Niue)',
      'Pacific/Pago_Pago':'(GMT-11:00) Samoa Standard Time (Pacific/Pago_Pago)',
    };
    
    _.each(Magellan.Util.Timezones.idToName, function(tzName, tzId) {
        Magellan.Util.Timezones.idToTimezone[tzId] = {
            id: tzId,
            name: tzName,
            gmtOffset: tzName.substr(1, tzName.indexOf(') ') - 1).replace('GMT', ''),
            label: tzName
        }
    });

    Magellan.Util.Timezones.getTimezoneTypeaheadData = function() {
      var browserTimezone = Magellan.Util.Timezones.guessUserTimezone();
      var preferredTimezones = browserTimezone ? [browserTimezone] : null;

      var typeaheadData = Object.values(Magellan.Util.Timezones.idToTimezone);
      var preferredTimezoneDetails = [];
      _.each(preferredTimezones, function(tz) {
        typeaheadData.remove(Magellan.Util.Timezones.idToTimezone[tz]);
        preferredTimezoneDetails.push(Magellan.Util.Timezones.idToTimezone[tz]);
      });
      typeaheadData = preferredTimezoneDetails.concat(typeaheadData);
      return typeaheadData;
    };

    Magellan.Util.Timezones.createTimezoneTypeahead = function(initialSelectionData) {
      var initialSelection;
      if (_.isEmpty(initialSelectionData)) {
        initialSelection = [];
      } else {
        initialSelection = [Magellan.Util.Timezones.idToTimezone[initialSelectionData]];
      }
      var typeaheadData = Magellan.Util.Timezones.getTimezoneTypeaheadData();
      return new Magellan.Views.NestedTypeaheadSelector({
        required: true,
        requireSelectionFromData: true,
        disableBreadcrumbs: true,
        data: {'timezones': typeaheadData},
        root: 'timezones',
        selection: initialSelection,
        placeholder: 'Select one',
        datumTokenizer: Magellan.Util.Timezones.datumTokenizer,
        queryTokenizer: function(query) {
          return Bloodhound.tokenizers.nonword(query).concat(Bloodhound.tokenizers.whitespace(query));
        }
      });
    };

    Magellan.Util.CreateUserListOverflow = function(pool, maxTextWidth) {
      if (pool.accessLevelAssignments && pool.accessLevelAssignments.length > 0) {
        var firstManager = pool.accessLevelAssignments[0];
        var otherManagers = pool.accessLevelAssignments.slice(1);
        
        var firstManagerName = firstManager.User__r ? firstManager.User__r.Name : firstManager.User__c;

        var maxWidthString = '';
        var otherManagersString = '';
        if (otherManagers.length > 0) {
          maxWidthString = ' style="max-width: ' + (maxTextWidth ? maxTextWidth + 'px' : '100%') + ';"';
          otherManagersString = '<div class="counter-bubble ld-body-small">+' + otherManagers.length + '<div class="counter-content">'
          _.each(otherManagers, function(manager) {
            var managerName = manager.User__r ? manager.User__r.Name : manager.User__c;
            otherManagersString += '<div>' + managerName + '</div>';
          });
          otherManagersString += '</div></div>';
        }

        return '<div class="pool-manager-column"' + maxWidthString + '>' + firstManagerName + '</div>' + otherManagersString;
      }
      return '';
    };

    Magellan.Util.shortenNumbers = function(n) {
      const digitCount = Math.ceil(Math.log10(n + 1));
      if (digitCount <= 3) { // easy case
        return '' + n;
      }
      const denominations = ['K', 'M', 'B', 'T', 'Qa', 'Qi'];
      const denomToUse = denominations[Math.ceil(digitCount / 3) - 2];
      let numericalPortion = (n / Math.pow(10, digitCount - 1 - ((digitCount - 1) % 3)));
      if (digitCount % 3 == 1) {
        numericalPortion = Math.floor(numericalPortion * 10) / 10;
      } else {
        numericalPortion = Math.floor(numericalPortion);
      }
      return numericalPortion + denomToUse;
    };

    Magellan.Util.formatUsageMetrics = function(rawRoutingMetrics) {
      let usageMetrics = [];
      let template = function() { return {
        total : 0,
        lead : 0,
        contact : 0,
        account : 0,
        opportunity : 0,
      };}
      
      let recordsRouted = template();
      let userCount = template();
      let uniqueUserIds = [];
      let idToRecordTypeCount = {};

      // loop through every date
      for (let date in rawRoutingMetrics) {
        let formattedDate = new Date(moment(date).format('MMMM D, YYYY'));
        let metricsOnDate = rawRoutingMetrics[date];
        let dailyUsageMetrics = {};
        let allRoutingUsers = {};

        // loop through object type under each date
        for (let objectType of Magellan.Util.objectTypes) {
          let objectTypeLowerCase = objectType.toLowerCase();
          let idToCount = metricsOnDate[objectTypeLowerCase];

          if (idToCount) {
            // update number of objects routed to users/queues
            for (let id in idToCount) {
              let objectsRoutedToId = idToCount[id];
              recordsRouted[objectTypeLowerCase] += objectsRoutedToId;
              recordsRouted['total'] += objectsRoutedToId;

              if (_.isUndefined(idToRecordTypeCount[id])) {
                idToRecordTypeCount[id] = template();  // create deep copyof obj with same keys
              }

              if (!uniqueUserIds.includes(id)) {
                uniqueUserIds.push(id);
              }

              idToRecordTypeCount[id][objectTypeLowerCase] += objectsRoutedToId;
            }
          }

          let objectRoutingUserKey = objectType + '_Routing_Users';
          dailyUsageMetrics[objectRoutingUserKey] = (!_.isUndefined(idToCount)) ? JSON.stringify(idToCount) : '{}';
          dailyUsageMetrics['Date'] = formattedDate;

          for (let routedToId in idToCount) {
            if (routedToId in allRoutingUsers) {
              allRoutingUsers[routedToId] += idToCount[routedToId];
            } else {
              allRoutingUsers[routedToId] = idToCount[routedToId];
            }
          }
        }

        // update max user across all objectTypes
        let dailyUserRoutedToCount = Object.keys(allRoutingUsers).length;
        dailyUsageMetrics['All_Routing_User_Count'] = dailyUserRoutedToCount;
        dailyUsageMetrics['All_Routing_Users'] = allRoutingUsers;
        usageMetrics.push(dailyUsageMetrics);
      }

      // Update total routed count for each Id
      Object.keys(idToRecordTypeCount).map(function(key, index) {
        for (objectType of Magellan.Util.objectTypes) {
          idToRecordTypeCount[key]['total'] += idToRecordTypeCount[key][objectType.toLowerCase()];
        }
      });

      const uniqueIdCount = uniqueUserIds.length;

      return {
        usageMetrics,
        recordsRouted,
        uniqueIdCount,
        idToRecordTypeCount,
      }
    };

    Magellan.Util.generateNodeMetricStats = function(node, currentGraphId) {
        var nodeFailureAndErrorStats = node.getFailureStats() + node.getErrorStats();
        var allMetricsEdgeNames = (nodeFailureAndErrorStats > 0) ? _.union(node.getSuccessEdgeNames(), node.getFailureEdgeNames(), node.getErrorEdgeNames()) : node.getSuccessEdgeNames();
        var longestEdgeMetricLength = _.reduce(allMetricsEdgeNames, function(highestCount, edgeName) { return Math.max(highestCount, String(node.getEdgeStats(edgeName)).length); }, 0);
        var longestEdgeNameLength = undefined;
        if (!(node instanceof Magellan.Models.TriggerNode)) {
          longestEdgeNameLength = _.reduce(_.union(allMetricsEdgeNames, [node.getDefaultName(true)]), function(highestCount, edgeName) { return Math.max(highestCount, Magellan.Migration.getFormattedEdgeName(edgeName).length); }, 0);
        }

        if (nodeFailureAndErrorStats > 0) {
          longestEdgeMetricLength = Math.max(longestEdgeMetricLength, String(nodeFailureAndErrorStats).length);
        }
        var metricToNameOffset = (longestEdgeMetricLength * 4.5) + 20.5;
        var infoBoxHeight;
        if (node.nodeInfo.type === 'MATCH' || node.nodeInfo.type === 'DECISION' || node.nodeInfo.type === 'REROUTING') {
          infoBoxHeight = 43; //this is the default size for 1 row in the metrics box display
        } else {
          infoBoxHeight = (nodeFailureAndErrorStats > 0) ? ((allMetricsEdgeNames.length + 1) * 25  ) + 28 : (allMetricsEdgeNames.length * 25) + 18; //firstchunk
        }

        // Translate number bubble and stat box based on node type to account for different sized nodes
        var metricBubbleTranslate = '80,37';
        if (node instanceof Magellan.Models.OutreachNode || node instanceof Magellan.Models.SalesloftNode) {
          metricBubbleTranslate = '135,35';
        }

        var EOFBubbletranslate = '36,68';
        if (node instanceof Magellan.Models.MatchNode) {
          EOFBubbletranslate = '38,70';
        } else if (node instanceof Magellan.Models.RerouteNode) {
          EOFBubbletranslate = '-20,40';
        }

        var statBoxTranslate = '120,55';
        if (node instanceof Magellan.Models.OutreachNode || node instanceof Magellan.Models.SalesloftNode) {
          statBoxTranslate = '175,55';
        } else if (node instanceof Magellan.Models.DecisionNode) {
          statBoxTranslate = '78,85';
        }

        return {
          'successStats' : node.getSuccessStats(),
          'failureAndErrorStats' : nodeFailureAndErrorStats,
          'danglingEdges' : node.getNumberOfDanglingEdges(),
          'allMetricsEdgeNames' : allMetricsEdgeNames,
          'longestEdgeMetricLength': longestEdgeMetricLength,
          'longestEdgeNameLength': longestEdgeNameLength,
          'metricToNameOffset': metricToNameOffset,
          'infoBoxHeight': infoBoxHeight,
          'pendingCCIOs': node.pendingCCIOs,
          'metricBubbleTranslate': metricBubbleTranslate,
          'EOFBubbletranslate': EOFBubbletranslate,
          'statBoxTranslate': statBoxTranslate,
        }
      };

  Magellan.Util.hasNotificationData = function(data) {
    return !_.isEmpty(data) && (!_.isEmpty(data.template) || Magellan.Util.hasRecipientsData(data.recipients));
  }

  Magellan.Util.hasRecipientsData = function(recipients) {
    var hasRecipients = false;

    _.each(recipients, function(val) {
      if (_.isBoolean(val) && val === true) {
        hasRecipients = true;
      } else if (!_.isEmpty(val)) {
        hasRecipients = true;
      }
    });

    return hasRecipients;
  }

  Magellan.Util.getDefaultNotificationSettings = function(emailsOnly) {
    var notifSettings = {
      template: null,
      recipients: {
        emails: [],
      }
    };

    if (!emailsOnly) {
      notifSettings.recipients.notifyPostOwner = false;
      notifSettings.recipients.notifyPreOwner = false;
      notifSettings.recipients.notifyNewObjectOwner = false;
      notifSettings.recipients.additionalObjectUserFields = [];
    }
    
    return notifSettings
  }
}

$.fn.toggleParentRow = function(rowId, duration) {
      $(this).toggleClass('collapsed');
      var $childRows = $(this).siblings('.child-row[data-id="' + rowId + '"]');

      var $cells = $childRows.children('td, th');
      if(!$cells.children().first().is('div')) {
        $childRows
          .children('td, th')
          .wrapInner('<div style="display:none" />');
      }
      if($(this).is('.collapsed')) {
        // $cells.animate({ paddingTop: 0, paddingBottom: 0 }, duration);
        $childRows
          .slideUp(duration)
          .children('td, th')
          .children()
          .slideUp(duration);
      } else {
        $childRows
          .slideDown(duration)
          .children('td, th')
          // .animate({ paddingTop: 5, paddingBottom: 5 }, duration)
          .children()
          .slideDown(duration);
      }
};

if (SVGElement && SVGElement.prototype) {
  SVGElement.prototype.hasClass = function (className) {
    return new RegExp('(\\s|^)' + className + '(\\s|$)').test(this.getAttribute('class'));
  };

  SVGElement.prototype.addClass = function (className) {
    if (!this.hasClass(className)) {
      this.setAttribute('class', this.getAttribute('class') + ' ' + className);
    }
  };
  SVGElement.prototype.removeClass = function (className) {
    var removedClass = this.getAttribute('class').replace(new RegExp('(\\s|^)' + className + '(\\s|$)', 'g'), '$2');
    if (this.hasClass(className)) {
      this.setAttribute('class', removedClass);
    }
  };
  SVGElement.prototype.toggleClass = function (className) {
    if (this.hasClass(className)) {
      this.removeClass(className);
    } else {
      this.addClass(className);
    }
  };
}

if (typeof module !== 'undefined') 
    module.exports = initializeMagellanUtil 
else 
    initializeMagellanUtil();
