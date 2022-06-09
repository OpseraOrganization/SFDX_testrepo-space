const clone = (object) => JSON.parse(JSON.stringify(object));

const map = (object, handler) => {
    let target;
    if(typeof object === 'object') {
        target = clone(object);
        if(Array.isArray(target)) {
            for(let i = 0, len = target?.length || 0; i < len; i++) {
                target[i] = handler(target[i], i);
            }
        }
        else {
            const keys = Object.keys(target || {});
            for(let i = 0, len = keys.length; i < len; i++) {
                target[keys[i]] = handler(target[keys[i]], keys[i]);
            }
        }
    }
    return target || object;
}

const filter = (object, handler) => {
    let result, target;
    if(typeof object === 'object') {
        target = clone(object);
        if(Array.isArray(target)) {
            result = [];
            for(let i = 0, len = target?.length || 0; i < len; i++) {
                if(handler(target[i], i) == true) { result = [...result, target[i]]; }
            }
        }
        else {
            result = {};
            const keys = Object.keys(target || {});
            for(let i = 0, len = keys.length; i < len; i++) {
                if(handler(target[keys[i]], keys[i]) == true) { result[keys[i]] = target[keys[i]]; }
            }
        }
    }
    return result;
}

const sleep = (milliseconds) => new Promise(resolve => setTimeout(resolve, milliseconds));

const dateFormatted = (date) => {
    if(!(date instanceof Date)) { date = new Date(date) }
    const day = date.getDate();
    const month = date.getMonth();
    const h = date.getHours(), m = date.getMinutes();
    return `${(day) < 10 ? '0' + (day) : (day)}/${(month+1) < 10 ? '0' + (month+1) : (month+1)}/${date.getFullYear()} ${h < 10 ? '0' + h : h}:${m < 10 ? '0' + m : m}`;
}

const dateYearAndMonth = (date) => {
    if(!(date instanceof Date)) { date = new Date(date) }
    const month = date.getMonth();
    return `${date.getFullYear()}-${(month+1) < 10 ? '0' + (month+1) : (month+1)}`;
}

const abbreviate = (value) => {
    let target;
    switch(typeof value) {
        case 'string':
            target = value.replace(/\s+/g,'');
            if(target.includes(',') || target.replace(/[^.]/g, "").length > 1) {
                target = target.split('.').join('').split(',').join('.');
            }
            target = Math.ceil(Number(target));
            break;
        case 'number':
            target = Math.ceil(value);
            break;
        default: return value;
    }
    if(isNaN(target) || target < 1000) { return value; }
    const suffixes = ["", "K", "M", "B","T"], suffixNum = Math.floor((""+target).length / 3);
    let shortValue = '';
    for(let p = 2; p >= 1; p--) {
        shortValue = parseFloat((suffixNum != 0 ? (target / Math.pow(1000,suffixNum) ) : target).toPrecision(p));
        if((shortValue + '').replace(/[^a-zA-Z 0-9]+/g,'')?.length <= 2) { break; }
    }
    if(shortValue % 1 != 0) { shortValue = shortValue.toFixed(1); }
    return shortValue + suffixes[suffixNum];
}

const retriveImage = async(url) => {
    const request = await fetch(url);
    if(request.ok) { return url; }//for better performance : URL.createObjectURL(await request.blob()); }
    else { return null; }
}

export { clone, map, sleep, filter, dateFormatted, dateYearAndMonth, abbreviate, retriveImage }