import { LightningElement } from 'lwc';
import user from '@salesforce/apex/octocatController.getCat';

export default class GithubCalloutCMP extends LightningElement {

cat;

connectedCallback(){
    user()
    .then(result =>{
        console.dir(JSON.stringify(result));
        this.cat = JSON.stringify(result);
    })
    .catch(err =>{
        console.dir(err);
    })
}

}