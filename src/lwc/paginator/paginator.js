/**
 * Created by Meiying Liang on 11/30/2019.
 */

import { LightningElement } from 'lwc';

export default class Paginator extends LightningElement {
    previousHandler() {
        this.dispatchEvent(new CustomEvent('previous'));
    }

    nextHandler() {
        this.dispatchEvent(new CustomEvent('next'));
    }
}