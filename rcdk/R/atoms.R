## An example of getting all the coordinates for a molecule
## atoms <- get.atoms(mol)
## coords <- do.call('rbind', lapply(apply, get.point3d))

.valid.atom <- function(atom) {
  if (is.null(attr(atom, 'jclass'))) stop("Must supply an Atom or IAtom object")
  if (!.check.class(atom, "org/openscience/cdk/interfaces/IAtom") &&
      !.check.class(atom, "org/openscience/cdk/Atom"))
    stop("Must supply an Atom or IAtom object")

  if (.check.class(atom, "org/openscience/cdk/Atom"))
    atom <- .jcast(atom, "org/openscience/cdk/interfaces/IAtom")
  return(atom)
}

#' Get the 3D coordinates of the atom.
#' 
#' In case, coordinates are unavailable (e.g., molecule was read in from a 
#' SMILES file) or have not been generated yet, `NA`'s are returned for the 
#' X, Y and Z coordinates.
#' 
#' @param atom The atom to query
#' @return A 3-element numeric vector representing the X, Y and Z coordinates.
#' @seealso \code{\link{get.point2d}}
#' @export
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
#' @examples 
#' \dontrun{
#' atoms <- get.atoms(mol)
#' coords <- do.call('rbind', lapply(apply, get.point3d))
#' }
get.point3d <- function(atom) {
  atom <- .valid.atom(atom)
  p3d <- .jcall(atom, "Ljavax/vecmath/Point3d;", "getPoint3d")
  if (is.jnull(p3d)) return( c(NA,NA,NA) )
  else {
    c(.jfield(p3d, name='x'),
      .jfield(p3d, name='y'),
      .jfield(p3d, name='z'))
  }
}

#' Get the 2D coordinates of the atom.
#' 
#' In case, coordinates are unavailable (e.g., molecule was read in from a 
#' SMILES file) or have not been generated yet, `NA`'s are returned for the 
#' X & Y coordinates.
#' 
#' @param atom The atom to query
#' @return A 2-element numeric vector representing the X & Y coordinates.
#' @seealso \code{\link{get.point3d}}
#' @export
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
#' @examples 
#' \dontrun{
#' atoms <- get.atoms(mol)
#' coords <- do.call('rbind', lapply(apply, get.point2d))
#' }
get.point2d <- function(atom) {
  atom <- .valid.atom(atom)    
  p3d <- .jcall(atom, "Ljavax/vecmath/Point2d;", "getPoint2d")
  if (is.jnull(p3d)) return( c(NA,NA) )
  else {
    c(.jfield(p3d, name='x'),
      .jfield(p3d, name='y'))
  }
}

#' Get the atomic symbol of the atom.
#' 
#' @param atom The atom to query
#' @return A character representing the atomic symbol
#' @export
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
get.symbol <- function(atom) {
  atom <- .valid.atom(atom)  
  .jcall(atom, "S", "getSymbol")
}

#' Get the atomic number of the atom.
#' 
#' @param atom The atom to query
#' @return An integer representing the atomic number
#' @export
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
get.atomic.number <- function(atom) {
  atom <- .valid.atom(atom)
  .jcall(.jcall(atom, "Ljava/lang/Integer;", "getAtomicNumber"), "I", "intValue")
}

#' Get the charge on the atom.
#' 
#' This method returns the partial charge on the atom. If charges have not been set the
#' return value is \code{NULL}, otherwise the appropriate charge.
#' 
#' @param atom The atom to query
#' @return An numeric representing the partial charge. If charges have not been set,
#' `NULL` is returned
#' @seealso \code{\link{get.formal.charge}}
#' @export
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
get.charge <- function(atom) {
  atom <- .valid.atom(atom)
  ch <- .jcall(atom, "Ljava/lang/Double;", "getCharge")
  if (!is.null(ch)) return(.jcall(ch, "D", "doubleValue"))
  else return(ch)
}

#' Get the formal charge on the atom.
#' 
#' By default the formal charge will be 0 (i.e., \code{NULL} is never returned).
#' 
#' @param atom The atom to query
#' @return An integer representing the formal charge
#' @seealso \code{\link{get.charge}}
#' @export
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
get.formal.charge <- function(atom) {
  atom <- .valid.atom(atom)
  ch <- .jcall(atom, "Ljava/lang/Integer;", "getFormalCharge")
  if (!is.null(ch)) return(.jcall(ch, "I", "intValue"))
  else return(ch)  
}

#' Get the implicit hydrogen count for the atom.
#' 
#' This method returns the number of implicit H's on the atom. 
#' Depending on where the molecule was read from this may be \code{NULL} or an integer
#' greater than or equal to 0
#' 
#' @param atom The atom to query
#' @return An integer representing the hydrogen count
#' @aliases hydrogen
#' @export
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
get.hydrogen.count <- function(atom) {
  atom <- .valid.atom(atom)  
  .jcall(.jcall(atom, "Ljava/lang/Integer;", "getImplicitHydrogenCount"), "I", "intValue")
}

#' Tests whether an atom is aromatic.
#' 
#' This assumes that the molecule containing the atom has been 
#' appropriately configured.
#' 
#' @param atom The atom to test
#' @return `TRUE` is the atom is aromatic, `FALSE` otherwise
#' @seealso \code{\link{is.aliphatic}}, \code{\link{is.in.ring}}, \code{\link{do.aromaticity}}
#' @export
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
is.aromatic <- function(atom) {
  atom <- .valid.atom(atom)
  flag.idx <- .jfield("org/openscience/cdk/CDKConstants", "I", "ISAROMATIC")
  .jcall(atom, "Z", "getFlag", as.integer(flag.idx))
}

#' Tests whether an atom is aliphatic.
#' 
#' This assumes that the molecule containing the atom has been 
#' appropriately configured.
#' 
#' @param atom The atom to test
#' @return `TRUE` is the atom is aliphatic, `FALSE` otherwise
#' @seealso \code{\link{is.in.ring}}, \code{\link{is.aromatic}}
#' @export
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
is.aliphatic <- function(atom) {
  atom <- .valid.atom(atom)
  flag.idx <- .jfield("org/openscience/cdk/CDKConstants", "I", "ISALIPHATIC")
  .jcall(atom, "Z", "getFlag", as.integer(flag.idx))
}

#' Tests whether an atom is in a ring.
#' 
#' This assumes that the molecule containing the atom has been 
#' appropriately configured.
#' 
#' @param atom The atom to test
#' @return `TRUE` is the atom is in a ring, `FALSE` otherwise
#' @seealso \code{\link{is.aliphatic}}, \code{\link{is.aromatic}}
#' @export
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
is.in.ring <- function(atom) {
  atom <- .valid.atom(atom)
  flag.idx <- .jfield("org/openscience/cdk/CDKConstants", "I", "ISINRING")
  .jcall(atom, "Z", "getFlag", as.integer(flag.idx))
}

#' Get atoms connected to the specified atom
#' 
#' Returns a `list`` of atoms that are connected to the specified atom.
#' @param atom The atom object
#' @param mol The `IAtomContainer` object containing the atom
#' @return A `list` containing `IAtom` objects, representing the atoms directly
#' connected to the specified atom
#' @export
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
get.connected.atoms <- function(atom, mol) {
  if (is.null(attr(mol, 'jclass')))
    stop("object must be of class IAtomContainer")
  
  if (attr(mol, 'jclass') != "org/openscience/cdk/interfaces/IAtomContainer")
    stop("object must be of class IAtomContainer")
  
  atom <- .valid.atom(atom)
  ret <- .jcall(mol, "Ljava/util/List;", "getConnectedAtomsList", atom)
  ret <- lapply(.javalist.to.rlist(ret), .jcast, new.class='org/openscience/cdk/interfaces/IAtom')
  return(ret)
}

#' Get the index of an atom in a molecule.
#' 
#' Acces the index of an atom in the context of an IAtomContainer. 
#' Indexing starts from 0. If the index is not known, -1 is returned.
#' 
#' @param atom The atom object
#' @param mol The `IAtomContainer` object containing the atom
#' @return An integer representing the atom index. 
#' @seealso \code{\link{get.bond.index}}
#' @export
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
get.atom.index <- function(atom, mol) {
  if (is.null(attr(mol, 'jclass')))
    stop("object must be of class IAtomContainer")
  
  if (attr(mol, 'jclass') != "org/openscience/cdk/interfaces/IAtomContainer")
    stop("object must be of class IAtomContainer")
  
  atom <- .valid.atom(atom)
  .jcall(mol, "I", "getAtomNumber", atom)
}
