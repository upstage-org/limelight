function sortTable(n, table){
  var switchcount = 0;        
  var switching = true;
  //Setting the sorting direction to ascending order.
  var direction = "ascending"; 
  //A loop that will continue until no switching has been done.
  while (switching){
    switching = false;
    var rows = table.getElementsByTagName("tr");
    if (typeof rows !== 'null'){
    //Loop through all table rows but not the table headers.
    for (var i = 1; i < (rows.length - 1); i++){
      //No switching at first.
      var shouldSwitch = false;
      //Compares the two elements, one from current row and one from the next.
      var x = rows[i].getElementsByTagName("td")[n];
      var y = rows[i + 1].getElementsByTagName("td")[n];
      //Check if the two needs switching based on the direction, ascending or descending order.
      if (direction == "ascending"){
        if (x.innerHTML.toLowerCase() > y.innerHTML.toLowerCase()){
          shouldSwitch = true;
          break;
        }
      } else if (direction == "descending"){
          if (x.innerHTML.toLowerCase() < y.innerHTML.toLowerCase()){
            shouldSwitch= true;
            break;
          }
        }
      }
      if (shouldSwitch){
        //If a switch has been marked, make the switch and then mark that a switch has been done.
        rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
        switching = true;
        switchcount ++;      
      } else{
          //If no switching has been done AND the direction is "ascending", will set the direction to "descending" and run the loop again.
          if (switchcount == 0 && direction == "ascending"){
            direction = "descending";
            switching = true;
          }
      }
    }
  }
}