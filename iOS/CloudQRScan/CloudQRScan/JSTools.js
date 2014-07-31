function MyAppGetHTMLElementsAtPoint(x,y) {
    var tags = ",";
    var e = document.elementFromPoint(x,y);
    while (e) {
        if (e.tagName) {
            tags += e.tagName + ',';
        }
        e = e.parentNode;
    }
    return tags;
}

function MyAppGetLinkSRCAtPoint(x,y) {
    var tags = "";
    var e = document.elementFromPoint(x,y);
    while (e) {
        if (e.src) {
            tags += e.src;
            break;
        }
        e = e.parentNode;
    }
    return tags;
}

function MyAppGetLinkHREFAtPoint(x,y) {
    var tags = "";
    var e = document.elementFromPoint(x,y);
    while (e) {
        if (e.href) {
            tags += e.href;
            break;
        }
        e = e.parentNode;
    }
    return tags;
}

/*
function elementFromPointIsUsingViewPortCoordinates() {
    if (window.pageYOffset > 0) {     // page scrolled down
        return (window.document.elementFromPoint(0, window.pageYOffset + window.innerHeight -1) == null);
    } else if (window.pageXOffset > 0) {   // page scrolled to the right
        return (window.document.elementFromPoint(window.pageXOffset + window.innerWidth -1, 0) == null);
    }
    return false; // no scrolling, don't care
}

function elementFromDocumentPoint(x,y) {
    if (elementFromPointIsUsingViewPortCoordinates()) {
        var coord = documentCoordinateToViewportCoordinate(x,y);
        return window.document.elementFromPoint(coord.x,coord.y);
    } else {
        return window.document.elementFromPoint(x,y);
    }
}

function elementFromViewportPoint(x,y) {
    if (elementFromPointIsUsingViewPortCoordinates()) {
        return window.document.elementFromPoint(x,y);
    } else {
        var coord = viewportCoordinateToDocumentCoordinate(x,y);
        return window.document.elementFromPoint(coord.x,coord.y);
    }
}
*/
/*
function MyAppGetHTMLElementsAtPoint1(x,y) {
    var
    var tags = "";
    var e;
    var checkpoint = 35;
    var offset = 0;
    
    while ((tags.search(",(A|IMG),") < 0) && (offset < checkpoint)) {
        tags = ",";
        e = document.elementFromPoint(x,y+offset);
        e=e.parentNode;
        
        if (e.tagName) {
            tags += e.tagName + ',';
        }

        e = document.elementFromPoint(x,y-offset);
        e=e.parentNode;
        
        if (e.tagName) {
            tags += e.tagName + ',';
        }

        
        /*
            if (e.src) {
                tags += ','+e.src ;
                
            }
            
            if (e.href) {
                tags += ','+e.href ;
                
            }
            
       
        /*
        var newe = e.parentNode;
        
        
            if (newe.tagName) {
                tags += "\nParent - "+newe.tagName ;
                
            }
            
            if (newe.src) {
                tags += ','+newe.src ;
                
            }
            
            if (newe.href) {
                tags += ','+newe.href ;
                
            }
            

        
        var newE = newe.getElementById('cphcloudQR_dsProfile');
       // while (newE) {
            if (newE.tagName) {
                tags += "\nRest - "+newE.tagName ;
                
            }
            
            if (newE.src) {
                tags += ','+newE.src ;
                
            }
            
            if (newE.href) {
                tags += ','+newE.href ;
                
            }
            
        //}

        
        
        
        /*
        while (e) {
            if (e.tagName) {
                tags += e.tagName + ',';
            }
            e = e.parentNode;
        }
        if (tags.search(",(A|IMG),") < 0) {
            e = document.elementFromPoint(x,y-offset);
            while (e) {
                if (e.tagName) {
                    tags += e.tagName + ',';
                }
                e = e.parentNode;
            }
        }
     // place the comment close here
        offset++;
    }
    return tags +" end";
}


function MyAppGetHTMLElementsAtPoint(x,y) {
 var tags = "";
 var e;
 var offset = -20;
 while ((tags.search(",(A|IMG),") < 0) && (offset < 20)) {
 tags = ",";
 e = document.elementFromDocumentPoint(x,y+offset);
 while (e) {
 if (e.tagName) {
 tags += e.tagName + ',';
 }
 e = e.parentNode;
 }
 if (tags.search(",(A|IMG),") < 0) {
 e = document.elementFromPoint(x,y-offset);
 while (e) {
 if (e.tagName) {
 tags += e.tagName + ',';
 }
 e = e.parentNode;
 }
 }
 
 offset++;
 }
 return tags;
 }
 
 function MyAppGetLinkSRCAtPoint(x,y) {
 var tags = "";
 var e = "";
 var offset = -20;
 while ((tags.length == 0) && (offset < 20)) {
 e = document.elementFromPoint(x,y+offset);
 while (e) {
 if (e.src) {
 tags += e.src;
 break;
 }
 e = e.parentNode;
 }
 if (tags.length == 0) {
 e = document.elementFromPoint(x,y-offset);
 while (e) {
 if (e.src) {
 tags += e.src;
 break;
 }
 e = e.parentNode;
 }
 }
 offset++;
 }
 return tags;
 }
 
 function MyAppGetLinkHREFAtPoint(x,y) {
 var tags = "";
 var e = "";
 var offset = -20;
 while ((tags.length == 0) && (offset < 20)) {
 e = document.elementFromPoint(x,y+offset);
 while (e) {
 if (e.href) {
 tags += e.href;
 break;
 }
 e = e.parentNode;
 }
 if (tags.length == 0) {
 e = document.elementFromPoint(x,y-offset);
 while (e) {
 if (e.href) {
 tags += e.href;
 break;
 }
 e = e.parentNode;
 }
 }
 offset++;
 }
 return tags;
 }
*/
 