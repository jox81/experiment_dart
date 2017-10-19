///This is a simple test to vérify the object passed by reférence are the same
void main() {
  buildTestNode();
}

Node nodeA;
Node nodeB;
void buildTestNode() {

  nodeA = new Node()..id = 1;
  nodeB = new Node()..id = 2;

  bindNodes();

  nodeA.node.id = 5;//alter only the first one

  assert(nodeA.node.id == nodeB.node.id);

  print(nodeA);
  print(nodeB);
}

void bindNodes() {
  Node nodeC= new Node()..id = 3;
  nodeA.node = nodeC;
  nodeB.node = nodeC;
}

class Node{
  Node node;
  int id;

  @override
  String toString() {
    return 'Node{node: $node, id: $id}';
  }
}
