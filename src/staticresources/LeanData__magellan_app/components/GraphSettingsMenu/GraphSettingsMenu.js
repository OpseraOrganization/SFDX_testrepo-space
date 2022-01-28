module.exports = function() {
  var template = require("./GraphSettingsMenu.template.html");

  var model = Magellan.Models.GraphSettingsMenu = Backbone.Model.extend({
    localStorageKey: "GraphSettingsMenuModelAttributes",
    defaults: {
      checkboxItems: [
          { name: 'enableGridlines', label: 'Enable Gridlines', value: false },
          { name: 'createThumbnail', label: 'Create Thumbnail on Save', value: true }
      ]
    },

    loadFromLocal: function() {
      var saved = JSON.parse(localStorage.getItem(this.localStorageKey) || null);
      if (saved) this.set(saved);
    },

    saveLocal: function() {
      localStorage.setItem(this.localStorageKey, JSON.stringify(this.attributes));
    },

    getSetting: function(settingName) {
      var setting = null;
      for (var key in this.attributes) {
        var settings = this.attributes[key];
        for(var i = 0, l = settings.length; i < l; i++) {
          var s = settings[i];
          if (s['name'] == settingName) {
            setting = s;
            break;
          }
        }

        if (setting !== null) break;
      }

      return setting;
    }
  });

  var view = Magellan.Views.GraphSettingsMenu = Backbone.View.extend({
    onChangeCallback: null,
    
    initialize: function(options) {
      var that = this;
      options = options || {};

      // set default model and callback for change event
      this.model = this.model || new model();
      this.onChangeCallback = typeof options.onChange === 'function' ? options.onChange : function() { return; };

      // handle clicks outside of the menu
      $('body').on('click', function(evt) {
        that.$el.find('.graph-settings-menu').trigger('toggle', false);
      });

      this.$el.on('click', function(e) {
        e.stopPropagation();
      });
    },

    events: {
      'click .graph-settings-menu-button': '_toggleButtonClicked',
      'change .checkboxSetting': '_checkboxSettingChanged',
      'toggle .graph-settings-menu': 'toggleMenu',
      'click #export-png-button': 'prepareDownload'
    },

    template: _.template(template),

    render: function() {
      var that = this;
      this.model.loadFromLocal();
      this.$el.html(this.template(this.model.attributes));

      return this;
    },
    prepareDownload() {
        this.$el.find('#export-png-button').text('Preparing');
        this.$el.find('#export-png-button').toggleClass('disabled', true);
        _.defer(this.exportPNG.bind(this));
    },
    exportPNG(){
        var createSVGViewBox = function(clientBox, opt) {
            var padding = joint.util.normalizeSides(opt.padding);
            if (opt.width && opt.height) {
                if (padding.left + padding.right >= opt.width) {
                    padding.left = padding.right = 0;
                }
                if (padding.top + padding.bottom >= opt.height) {
                    padding.top = padding.bottom = 0;
                }
            }

            var paddingBox = g.rect({
                x: -padding.left,
                y: -padding.top,
                width: padding.left + padding.right,
                height: padding.top + padding.bottom
            });

            if (opt.width && opt.height) {
                var paddingWidth = clientBox.width + padding.left + padding.right;
                var paddingHeight = clientBox.height + padding.top + padding.bottom;
                paddingBox.scale(paddingWidth / opt.width, paddingHeight / opt.height);
            }
            return g.Rect(clientBox).moveAndExpand(paddingBox);
        }

        var scaleRasterSize = function(size, scale) {
            return {
                width: (size.width || 1) * scale,
                height: (size.height || 1) * scale
            };
        }

        var getScale = function(size) {
            var scale = 1;
            if (!_.isUndefined(size)) {
                scale = parseFloat(size);
                if (!_.isFinite(scale) || scale === 0) {
                    throw new Error('dia.Paper: invalid raster size (' + size + ')');
                }
            }
            return scale;
        }

        function replaceSVGImagesWithSVGEmbedded(svg) {
            return svg.replace(/\<image[^>]*>/g, function(imageTag) {
                var href = imageTag.match(/href="([^"]*)"/)[1];
                var svgDataUriPrefix = 'data:image/svg+xml';

                if (href.substr(0, svgDataUriPrefix.length) === svgDataUriPrefix) {
                    var svg = atob(href.substr(href.indexOf(',') + 1));
                    return svg.substr(svg.indexOf('<svg'));
                }

                return imageTag;
            });
        }

        var convertToSVG = function(callback, opt) {
            opt = opt || {};

            paper.trigger('beforeexport', opt);
            var viewportBBox = (opt.area)
                ? opt.area
                : V.transformRect(paper.getContentBBox(), paper.matrix().inverse());

            var svgClone = paper.svg.cloneNode(true);
            svgClone.removeAttribute('style');

            if (opt.preserveDimensions) {
                V(svgClone).attr({
                    width: viewportBBox.width,
                    height: viewportBBox.height
                });
            }

            V(svgClone).findOne('.joint-viewport').removeAttr('transform');
            V(svgClone).attr('viewBox', viewportBBox.x + ' ' + viewportBBox.y + ' ' + viewportBBox.width + ' ' + viewportBBox.height);

            var styleSheetsCount = document.styleSheets.length;
            var styleSheetsCopy = [];

            for (var i = styleSheetsCount - 1; i >= 0; i--) {
                styleSheetsCopy[i] = document.styleSheets[i];
                document.styleSheets[i].disabled = true;
            }
            var defaultComputedStyles = {};
            $(paper.svg).find('*').each(function(idx) {
                var computedStyle = window.getComputedStyle(this, null);
                var defaultComputedStyle = {};
                _.each(computedStyle, function(property) {
                    defaultComputedStyle[property] = computedStyle.getPropertyValue(property);
                });
                defaultComputedStyles[idx] = defaultComputedStyle;
            });

            if (styleSheetsCount != document.styleSheets.length) {
                _.each(styleSheetsCopy, function(copy, i) {
                    document.styleSheets[i] = copy;
                });
            }

            for (var j = 0; j < styleSheetsCount; j++) {
                document.styleSheets[j].disabled = false;
            }

            var customStyles = {};
            $(paper.svg).find('*').each(function(idx) {
                var computedStyle = window.getComputedStyle(this, null);
                var defaultComputedStyle = defaultComputedStyles[idx];
                var customStyle = {};

                _.each(computedStyle, function(property) {
                    if (computedStyle.getPropertyValue(property) !== defaultComputedStyle[property]) {
                        customStyle[property] = computedStyle.getPropertyValue(property);
                    }
                });

                customStyles[idx] = customStyle;
            });

            var images = [];

            $(svgClone).find('*').each(function(idx) {
                $(this).css(customStyles[idx]);
                if (this.tagName.toLowerCase() === 'image' && !['paste','copy','edit','delete'].includes($(this).attr('action'))) {
                    images.push(this);
                }
            });

            var totalImages = images.length;
            var numberOfImagesLeft = images.length;

            paper.trigger('afterexport', opt);

            function serialize() {
                return (new XMLSerializer())
                    .serializeToString(svgClone)
                    .replace(/&nbsp;/g, '\u00A0');
            }

            function convertImages(done) {
                $('#export-png-button').text(Math.floor((((totalImages - numberOfImagesLeft)/totalImages)*100))+'%');
                numberOfImagesLeft--;
                var image = V(images.shift());
                if (!image) return done();

                var url = image.attr('xlink:href') || image.attr('href');

                joint.util.imageToDataUri(url, function(err, dataUri) {
                    image.attr('xlink:href', dataUri);
                    convertImages(done);
                });
            }

            if (opt.convertImagesToDataUris && images.length) {
                convertImages(function() {
                    callback(serialize());
                });
            } else {
                return callback(serialize());
            }
        };

        var generateGraphPNG = function(callback, opt) {
            opt = opt || {};
            opt.type = 'image/png';

            var clientRect = V.transformRect(paper.getContentBBox(), paper.matrix().inverse());
            var svgViewBox = createSVGViewBox(clientRect, opt);

            var dimensions = (opt.width && opt.height) ? opt : svgViewBox;
            var rasterSize = scaleRasterSize(dimensions, getScale(opt.size));

            var img = new Image();
            var svg;

            img.onload = function() {
                var dataURL, context, canvas;

                function createCanvas() {
                    canvas = document.createElement('canvas');
                    canvas.width = rasterSize.width;
                    canvas.height = rasterSize.height;
                    context = canvas.getContext('2d');
                    context.fillStyle = opt.backgroundColor || 'white';
                    context.fillRect(0, 0, rasterSize.width, rasterSize.height);
                }

                function readCanvas() {
                    dataURL = canvas.toDataURL(opt.type, opt.quality);
                    callback(dataURL);
                    if (canvas.svg && _.isFunction(canvas.svg.stop)) {
                        _.defer(canvas.svg.stop);
                    }
                }

                createCanvas();

                try {
                    context.drawImage(img, 0, 0, rasterSize.width, rasterSize.height);
                    readCanvas(); 
                } catch (e) {
                    if (typeof canvg === 'undefined') {
                        console.error('Canvas tainted. Canvg library required.');
                        return;
                    }

                    createCanvas();

                    var canvgOpt = {
                        ignoreDimensions: true,
                        ignoreClear: true,
                        ignoreMouse: true,
                        ignoreAnimation: true,
                        offsetX: 0,
                        offsetY: 0,
                        useCORS: true
                    };

                    canvg(canvas, svg, _.extend(canvgOpt, {
                        forceRedraw: _.once(function() {
                            return true;
                        }),
                        renderCallback: function() {
                            try {
                                readCanvas();
                            } catch (e) {
                                svg = replaceSVGImagesWithSVGEmbedded(svg);
                                createCanvas();
                                canvg(canvas, svg, _.extend(canvgOpt, { renderCallback: readCanvas }));
                            }
                        }
                    }));
                }
            };

            convertToSVG(function(svgString) {
                svg = svgString = svgString.replace('width="100%"', 'width="' + rasterSize.width + '"')
                    .replace('height="100%"', 'height="' + rasterSize.height + '"');
                img.src = 'data:image/svg+xml,' + encodeURIComponent(svgString);
            }, { convertImagesToDataUris: true, area: svgViewBox });
        };

        var now = Date.now();

        generateGraphPNG(function(image) {
            var downloadedGraphName = $('#graph-name').val()+'.png';
            download(image, downloadedGraphName, 'image/png');
            $('#export-png-button').text('Export Graph as Image (.png)');
            $('#export-png-button').toggleClass('disabled', false);
        })
    },

    toggleMenu: function(evt, value) {
      // TODO: There gotta be a better way of handling toggle menu without grabbing it globally with jquery
      // when clicking anywhere on body it should close the menu, right now jquery not toggling class correct

      // determine if the event came from the menu itself else must be one of its children
      //var menu = $(evt.target).is(this.$el.find('.graph-settings-menu')) ? $(evt.target) : $(evt.target).closest('.graph-settings-menu');
      // var alreadyOpen = menu.classList.contains('open');
      // var doOpen = _.isUndefined(value) ? !alreadyOpen : value;
      //
      // if (!doOpen || alreadyOpen) {
      //     menu.classList.remove('open');
      // } else if (!alreadyOpen) {
      //     menu.classList.add('open');
      // }
      // menu.toggleClass('open', value);

      if (j$(evt.target).is(this.$el.find('.graph-settings-menu'))) {
        j$('.graph-settings-menu').toggleClass('open', value);
      } else {
        j$(evt.target).closest('.graph-settings-menu').toggleClass('open', value);
      }
    },
    onChange: function(callback) {
      this.onChangeCallback = callback;
    },
    _toggleButtonClicked: function(evt, value) {
      this.toggleMenu(evt, value);
    },
    _checkboxSettingChanged: function(evt) {
      var itemName = $(evt.target).prop('name');
      var item = this.model.get('checkboxItems').find(function(obj) {
          return obj.name === itemName;
      });
      item.value = $(evt.target).is(":checked");

      this._settingChanged(item, evt);
    },
    _settingChanged: function(changedItem, evt) {
      this.onChangeCallback(changedItem, evt);
      this.model.saveLocal();
    }
  });
};